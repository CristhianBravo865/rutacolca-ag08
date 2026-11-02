# AG-10 — Evaluación cruzada ATAM ligera

- **Evaluador:** Cristhian Matias Bravo Arredondo
- **Escenario propio:** E2 — Disponibilidad (la pasarela no responde 15 min; 0 reservas pagadas perdidas; confirmación ≤ 30 min tras la recuperación).
- **ADR propio de referencia:** [ADR-003 — Conciliar pagos con estados persistentes e idempotencia](../../adr/ADR-003-recuperacion-pagos.md).
- **Diseño a evaluar:** el del escenario siguiente, **E3 — Seguridad** (regla de la consigna: E2 → E3): «un operador intenta modificar un tour de otra agencia; 100 % de intentos bloqueados y auditados».

## 1. Qué observaríamos en un diseño para E3

Guía de evaluación preparada a partir de la Tabla 4, el Anexo A y el riesgo OWASP API1:2023 (autorización a nivel de objeto). Cada fila indica qué buscaríamos en el ADR de E3 y por qué importa para los cinco escenarios, no solo para E3.

| Tipo | Qué observaríamos | Escenario afectado | Mitigación que esperaríamos ver |
|---|---|---|---|
| Riesgo | Que la autorización se compruebe solo por rol o por ruta HTTP y no por objeto: un operador con rol válido podría editar un tour de otra agencia. | E3 | Verificar en cada operación que el tour pertenezca a la agencia del operador, con pruebas automatizadas por endpoint. |
| Riesgo | Que algún camino de modificación (endpoint nuevo, carga masiva, portal sin conexión que sincroniza después) no pase por la misma verificación. | E3 | Un único punto de autorización en el módulo de tours que usen todos los caminos. |
| Riesgo | Que el registro de auditoría guarde datos sensibles (tokens, datos de pago) o se pueda modificar. | E3 | Auditoría de solo escritura con quién, qué, cuándo y resultado, sin secretos. |
| Punto de sensibilidad | Qué pasa si la auditoría falla o está lenta: ¿se bloquea la modificación o se permite sin auditar? La medida «100 % auditado» depende de esa decisión. | E3 vs. disponibilidad | Política explícita (por ejemplo, rechazar la operación si no se puede auditar) y su impacto medido. |
| Punto de sensibilidad | Costo por petición de la verificación de propiedad (consulta adicional a PostgreSQL). | E1 | Medir el p95 con la verificación activa frente a 1,5 s. |
| Trade-off | Más seguridad (verificar y auditar cada operación) a cambio de más latencia y más escrituras en la base de datos en temporada alta. | E3 vs. E1 | Índices sobre agencia/tour y auditoría eficiente. |
| Trade-off | Si la auditoría o la autorización se aplican también a tareas internas, como la conciliación de pagos de E2, pueden frenarla; si no se aplican, queda un camino sin control. | E3 vs. E2 | Identidad de sistema separada con permisos mínimos y auditada. |

## 2. Preguntas para el grupo de E3

1. ¿La autorización para modificar un tour se comprueba **por objeto y por agencia** (el tour pertenece a quien lo pide), y no solo por la ruta HTTP o el rol?
2. ¿Cómo se garantiza el «100 % auditado»? ¿El registro de auditoría guarda quién, qué, cuándo y el resultado, **sin** incluir credenciales ni datos de pago?
3. ¿Qué costo de latencia añade la verificación en cada petición y cómo afecta al p95 ≤ 1,5 s de **E1**?
4. Las tareas en segundo plano (por ejemplo, la conciliación de pagos de **E2**), ¿quedan sujetas a las mismas reglas de autorización y auditoría, o usan una identidad de sistema separada?
5. Si la auditoría falla (base de datos lenta o caída), ¿se bloquea la modificación o se permite sin auditar? Cada opción afecta a E3 o a la disponibilidad.
6. ¿Cómo verifican la medida? ¿Hay una prueba que intente modificar tours de otra agencia en todos los endpoints y compruebe el bloqueo y el registro?

## 3. Observaciones internas sobre el ADR propio (E2)

Sirven para responder las preguntas que otro grupo nos haga sobre ADR-003.

| Tipo | Observación | Escenario afectado | Mitigación en ADR-003 |
|---|---|---|---|
| Riesgo | El proveedor puede haber cobrado y perderse la respuesta. Reintentar el cobro **sin consultar antes** el estado podría duplicar el cargo. | E2 | Estado INCIERTO, consulta por la misma clave idempotente antes de reintentar. |
| Riesgo | Si la pasarela real no permite consultar por clave idempotente, no se puede prometer «sin dobles cargos». | E2, E4 | Validar el contrato real del proveedor antes de producción. |
| Punto de sensibilidad | Frecuencia del conciliador y tamaño de lote: con intervalos largos o lotes chicos, los pendientes acumulados en 15 min podrían no confirmarse en ≤ 30 min. | E2 | Medir la edad de los pendientes y alertar antes del límite. |
| Punto de sensibilidad | Coordinación entre las 2 réplicas de la API: sin bloqueo o *lease*, dos réplicas podrían procesar la misma reserva. | E2 | Bloqueo/lease transaccional y pruebas de concurrencia. |
| Trade-off | Más resiliencia (E2) a cambio de más escrituras y consultas en PostgreSQL durante la demanda alta (E1). | E2 vs. E1 | Lotes limitados, índices y límite de tasa del conciliador. |
| Trade-off | Confirmar solo pagos comprobados retrasa la confirmación al turista (experiencia de uso) a cambio de no confirmar pagos inexistentes. | E2 | Mostrar «pendiente de confirmación» al usuario. |

## 4. Coherencia entre ADR-003 y la prueba de concepto

Verificado contra [`src/ag10/PagoResiliente.java`](../../../../src/ag10/PagoResiliente.java):

- [x] Los estados de la POC (`PENDIENTE`, `INCIERTO`, `CONFIRMADO`, `RECHAZADO`) coinciden con los de ADR-003.
- [x] La POC consulta `estaPagado(clave)` **antes** de `cobrar(clave)` y vuelve a consultar tras una respuesta incierta.
- [x] La prueba cubre caída de 15 min, confirmación ≤ 30 min tras la recuperación y respuesta perdida sin doble cobro.
- [ ] No cubre persistencia en PostgreSQL, reinicios ni concurrencia entre 2 réplicas (límite declarado de la POC).
