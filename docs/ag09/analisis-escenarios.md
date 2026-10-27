# AG-09 — Análisis de los cinco escenarios de RutaColca

**Responsable:** Fernando Luque — Analista de escenarios y coordinador  
**Curso:** Construcción de Software · Tema 09: Patrones de diseño  
**Caso base:** RutaColca (AG-08) · **Estado:** propuesta técnica inicial, pendiente de revisión grupal  
**Destino en el repositorio:** `docs/ag09/analisis-escenarios.md`

## 1. Objetivo y fuentes

Identificar el problema de diseño en los cinco escenarios de la práctica AG-09, proponer un patrón GoF o una solución directa y justificar la decisión con principios de diseño. **Este archivo es un análisis de diseño, no evidencia de una implementación existente.**

- **Consigna:** *Tema 09: Patrones de diseño*, pp. 33–35. Plantea cinco escenarios, solicita dos diagramas PlantUML y exige detectar dónde no se justifica un patrón.
- **Contexto arquitectónico:** repositorio [`rutacolca-ag08`](https://github.com/CristhianBravo865/rutacolca-ag08), especialmente [`inventario.md`](https://github.com/CristhianBravo865/rutacolca-ag08/blob/main/docs/architecture/c4/ruta-colca/inventario.md) y [`workspace.dsl`](https://github.com/CristhianBravo865/rutacolca-ag08/blob/main/docs/architecture/c4/ruta-colca/workspace.dsl). El modelo C4 describe una API Java 21/Spring Boot, PostgreSQL, pasarela de pagos, WhatsApp Business y AUTOCOLCA; no acredita clases GoF ya implementadas.
- **Criterio de selección:** encapsular lo que varía, programar para interfaces, composición sobre herencia, principio abierto/cerrado y bajo acoplamiento (Tema 09, p. 13).

## 2. Matriz de análisis

| N.º | Escenario de la consigna | Problema de diseño | Decisión propuesta | Principio y justificación |
|---|---|---|---|---|
| 1 | Cobrar con tarjeta, Yape y PayPal | Los distintos proveedores podrían obligar al flujo de reserva a conocer llamadas y formatos particulares. | **Adapter** cuando las API sean incompatibles; interfaz común `PasarelaPago`. **No introducir una Factory independiente por defecto.** | **Programar para interfaces / bajo acoplamiento:** `ReservaService` invoca un contrato común; cada adaptador traduce solo su proveedor. Una fábrica adicional requiere demostrar que la creación está dispersa o es compleja. |
| 2 | Precio por temporada, grupo o estudiante | La política de cálculo cambia y puede generar condicionales de tarifas en la lógica de reservas. | **Strategy**: `PoliticaPrecio`, `PrecioTemporada`, `PrecioGrupo`, `PrecioEstudiante`. | **Encapsular lo que varía / abierto-cerrado:** nuevas políticas pueden añadirse sin reescribir el cálculo central. Se debe definir cómo interactúan descuentos combinados. |
| 3 | Avisar al turista, guía y agencia tras confirmar reserva | El módulo de reservas queda acoplado a varios mecanismos y destinatarios de avisos. | **Observer**: `PublicadorReserva` y `ObservadorReserva` con tres implementaciones. | **Bajo acoplamiento / abierto-cerrado:** el flujo publica el evento `ReservaConfirmada` sin codificar cada destinatario. Los avisos no deben convertir un fallo externo en una confirmación duplicada. |
| 4 | API de AUTOCOLCA incompatible con la esperada | La API externa emplea contratos, operaciones o respuestas distintas de las del sistema. | **Adapter**: `AutocolcaAdapter` implementa `ValidadorBoleto` y delega a `AutocolcaClient`. | **Programar para interfaces / separación de cambios:** la lógica de validación no depende directamente del contrato externo. |
| 5 | Disponibilidad consultada cientos de veces | Las consultas frecuentes podrían provocar sobrecarga o datos obsoletos si se añaden cachés sin control. | **Sin patrón GoF inicialmente**: consulta directa mediante un servicio/repositorio ya existente. Considerar **Proxy con caché** solo si las mediciones lo justifican. | **Simplicidad / evitar paternite:** la frecuencia por sí sola no demuestra lentitud. Una caché añade invalidación, vencimiento y riesgos de disponibilidad desactualizada. |

> **Distinción importante:** el PDF describe situaciones hipotéticas de crecimiento. El nombre de las clases y las decisiones anteriores son propuestas del equipo para analizar, no clases verificadas en el repositorio.

## 3. Análisis de cada escenario

### Escenario 1 — Medios de pago

**Situación.** RutaColca debe aceptar tarjeta, Yape y PayPal. En el modelo C4 ya aparece una pasarela externa de pagos, pero la consigna amplía los medios concretos. 

**Riesgo de diseño.** Si `ReservaService` decide cómo cobrar utilizando `if/else` con detalles de cada proveedor, cualquier cambio externo afectará el flujo de negocio.

**Solución propuesta.** Establecer `PasarelaPago.cobrar(solicitud): ResultadoPago`, con adaptadores concretos únicamente para proveedores cuyos contratos no coincidan con esta interfaz. Los detalles de credenciales, errores, monedas y confirmación quedan encapsulados fuera de `ReservaService`.

**Alternativa descartada por ahora.** Crear `PasarelaFactory` como patrón separado sin evidencia de construcción repetida en distintos puntos. Una selección simple en la configuración/composición del sistema puede bastar; si aparecen muchos lugares construyendo adaptadores, se reconsiderará una fábrica.

**Consecuencia.** Se incorporan clases adicionales, a cambio de aislar integraciones. No se asume que las API reales de Yape o PayPal posean firmas concretas: son contratos por definir.

### Escenario 2 — Variación de tarifas

**Situación.** La tarifa depende de temporada, condición de grupo o estudiante.

**Riesgo de diseño.** Un solo método con condiciones encadenadas concentra reglas comerciales y se modifica cada vez que surge una nueva política.

**Solución propuesta.** Definir `PoliticaPrecio.calcular(contexto): Importe`, implementada por `PrecioTemporada`, `PrecioGrupo` y `PrecioEstudiante`. `CalculadorPrecio` utiliza una política seleccionada para la reserva.

**Restricción abierta.** La consigna **no define si las tarifas se excluyen, se priorizan o pueden acumularse**. Para los dos diagramas, modelar inicialmente una política activa por cálculo; si el docente especifica combinaciones, revisarlas antes de implementar. No inventar porcentajes ni reglas de prioridad.

**Consecuencia.** Es sencillo agregar variantes independientes, pero la elección de política debe estar centralizada y probada.

### Escenario 3 — Notificaciones tras confirmar

**Situación.** Tras confirmar la reserva, se avisa al turista, al guía y a la agencia. En AG-08 se reconoce a WhatsApp Business como sistema externo y al guía como destinatario de comunicaciones.

**Riesgo de diseño.** El código que confirma una reserva tendría que depender directamente de varios canales de notificación y de la lista de receptores.

**Solución propuesta.** `PublicadorReserva` publica `ReservaConfirmada`; observadores `NotificadorTurista`, `NotificadorGuia` y `NotificadorAgencia` reaccionan al evento. El canal específico de cada receptor es un detalle de implementación, no algo demostrado en la consigna.

**Precaución.** Diferenciar la confirmación persistida de la entrega posterior de avisos. Si se implementa más adelante, considerar reintentos e idempotencia; **Observer por sí solo no garantiza entrega de mensajes**.

**Consecuencia.** Los destinatarios se pueden incorporar sin cambiar la confirmación central, a costa de gestionar fallas parciales y trazabilidad.

### Escenario 4 — Integración AUTOCOLCA

**Situación.** La consigna dice explícitamente que la API de AUTOCOLCA no coincide con la interfaz que espera RutaColca. El inventario de AG-08 la describe como API HTTPS supuesta para el ejercicio.

**Riesgo de diseño.** La lógica de la reserva o del boleto depende de formatos ajenos y debe modificarse ante cambios del servicio externo.

**Solución propuesta.** `ValidadorBoleto.validar(datos): ResultadoValidacion` como interfaz propia, `AutocolcaAdapter` como adaptador y `AutocolcaClient` como cliente externo. El adaptador transforma solicitudes, respuestas y errores.

**Consecuencia.** El resto de RutaColca trata con un contrato estable y puede probarse con un validador simulado. No se inventan endpoints de AUTOCOLCA.

### Escenario 5 — Consultas de disponibilidad sin patrón (propuesto)

**Situación.** El sistema recibe cientos de consultas de disponibilidad.

**Riesgo de diseño.** Un Proxy con caché podría evitar consultas repetidas, pero si la disponibilidad cambia al reservar cupos, puede mostrar información obsoleta y complicar la consistencia.

**Decisión inicial.** Mantener `DisponibilidadService.consultar(salida)` con acceso directo al repositorio de datos y optimizar primero la consulta real (por ejemplo, revisar índices y consultas). **No añadir de entrada un `DisponibilidadProxy` solo para exhibir otro patrón.**

**Condición de reconsideración.** Si se observan latencias o saturación, evaluar un proxy con caché, TTL e invalidación explícita al modificar cupos. Diferenciar mostrar disponibilidad informativa de **confirmar/reservar cupos**, operación que siempre requiere validación consistente.

**Justificación de no aplicar un patrón.** El número de accesos no basta para probar que existe un cuello de botella. Este es el caso elegido para demostrar que una solución directa puede ser preferible: evita la *paternite* y el coste de mantener abstracciones prematuras.

## 4. Acuerdos propuestos para el integrante 2 (diagramas UML)

Se proponen **dos escenarios**, sujetos a confirmación del equipo:

| Diagrama | Escenario | Roles mínimos y nombres acordados | Relaciones que deben verse |
|---|---|---|---|
| `patron-1.puml` | 2 — Strategy (tarifas) | Cliente/contexto: `CalculadorPrecio`; estrategia: `PoliticaPrecio`; concretas: `PrecioTemporada`, `PrecioGrupo`, `PrecioEstudiante`; dato de entrada: `ContextoTarifa`. | `CalculadorPrecio` **tiene una** `PoliticaPrecio`; tres estrategias **implementan** el contrato. |
| `patron-2.puml` | 3 — Observer (notificaciones) | Sujeto: `PublicadorReserva`; observador: `ObservadorReserva`; concretas: `NotificadorTurista`, `NotificadorGuia`, `NotificadorAgencia`; evento: `ReservaConfirmada`; cliente: `ReservaService`. | `ReservaService` publica la confirmación; `PublicadorReserva` **mantiene una colección** de `ObservadorReserva`; tres notificaciones implementan la interfaz. |

**Contratos sugeridos (orientativos; no código existente):**

```text
PoliticaPrecio.calcular(contexto: ContextoTarifa): Importe
CalculadorPrecio.calcular(contexto: ContextoTarifa): Importe
ObservadorReserva.actualizar(evento: ReservaConfirmada): void
PublicadorReserva.suscribir(observador: ObservadorReserva): void
PublicadorReserva.publicar(evento: ReservaConfirmada): void
```

**Para evitar discrepancias:** usar el término *reserva* (no *pedido*) en los diagramas de RutaColca; mantener `ReservaService` en Observer y los nombres de clases de esta tabla.

## 5. Decisiones para contrastar con el integrante 3 (IA)

Pedirle a la IA una recomendación independiente por escenario, con la posibilidad explícita de **no usar un patrón**. Comparar en especial:

1. Si propone **Factory** obligatoriamente para pagos, solicitar evidencia de múltiples puntos de creación antes de aceptarla.
2. Si propone combinar múltiples Strategies para tarifas, comprobar que exista una regla real de acumulación.
3. Si presenta Observer como solución de entrega garantizada, señalar que el patrón no resuelve ese requisito.
4. Si propone saltarse el Adapter e invocar AUTOCOLCA desde la lógica central, evaluar el acoplamiento a una API incompatible.
5. Si propone **Proxy/caché** sin considerar obsolescencia de cupos, preferir inicialmente la solución directa o pedir una política de invalidación.

La **bitácora real de respuestas de IA** corresponde al integrante 3; este análisis no atribuye recomendaciones concretas a una IA que todavía no haya sido consultada por ese integrante.

## 6. Criterios de revisión y decisiones pendientes

- [x] Identificados los cinco problemas de diseño.
- [x] Justificados patrones y alternativa sin patrón.
- [x] Definidos dos escenarios y contratos UML propuestos.
- [x] Redactada una justificación explícita de *paternite* para el escenario 5.
- [ ] Validar con el equipo los dos patrones a diagramar y los nombres de clase.
- [ ] Confirmar reglas de combinación de tarifas si hay requisitos adicionales.
- [ ] Verificar que diagramas y evaluación de IA coincidan con el análisis final.
- [ ] Someter el archivo a revisión cruzada y fusionar su PR.

## 7. Entrega y coordinación en GitHub

```bash
# Tras clonar el repositorio y ubicarse en su raíz:
git switch main
git pull origin main
git switch -c ag09/analisis
mkdir -p docs/ag09
# Copiar este documento a docs/ag09/analisis-escenarios.md
git add docs/ag09/analisis-escenarios.md
git commit -m "docs(ag09): analizar cinco escenarios de patrones"
git push -u origin ag09/analisis
```

Abrir un PR hacia `main`. Enviarle al integrante 2 la tabla de la sección 4 y al integrante 3 los puntos de contraste de la sección 5. El integrante 4 puede integrar este documento tras su revisión. **No se realizaron commits ni cambios remotos desde esta entrega.**
