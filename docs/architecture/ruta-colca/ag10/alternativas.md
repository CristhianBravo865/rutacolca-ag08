# AG-10 — Iteración ADD para E2 (disponibilidad de pagos)

## 1. Drivers heredados

- Evolucionar RutaColca sin reconstruirlo.
- Conservar el monolito modular (ADR-001), API Java 21/Spring Boot y PostgreSQL 16.
- Equipo de cuatro personas, hasta tres semanas para cambios de diseño; justificar infraestructura nueva.
- Escenario E2: pasarela caída 15 min; ninguna reserva pagada perdida; confirmación de pendientes ≤ 30 min tras recuperación.
- Mantener la validación AUTOCOLCA antes de cobrar; no afectar E3 ni exponer credenciales.

## 2. ADD: pasos de la iteración

| Paso | Aplicación |
|---|---|
| 2. Objetivo | Recuperar y conciliar pagos tras indisponibilidad, evitando pérdidas y cobros duplicados. |
| 3. Elementos a refinar | API: módulos Reservas y Pagos, contrato `PasarelaPago`, persistencia PostgreSQL y relación API → pasarela. |
| 4. Conceptos de diseño | Timeouts, retry con backoff, idempotencia, persistencia de estados, conciliación y separación entre solicitud/confirmación. |
| 5. Instanciar | `RegistroIntentosPago`, `ConciliadorPagos`, `PasarelaPago`, `RepositorioReservas`; tareas de recuperación dentro de las réplicas de API con coordinación para no duplicar procesos. |

Los nombres son **componentes propuestos**, no clases verificadas en el repositorio.

## 3. Alternativas comparadas

| Criterio | A. PostgreSQL + conciliador dentro del monolito | B. Broker/cola externa + consumidor de pagos |
|---|---|---|
| Tácticas | Timeout, persistencia, retry acotado, consulta de estado, idempotencia | Cola duradera, desacoplamiento temporal, reintentos, consumidor idempotente |
| Patrón/tecnología | Repositorio persistente + tarea programada + Adapter existente si aplica | Mensajería asíncrona, patrón productor-consumidor, broker administrado |
| Mecanismo | Conservar estado de intento y clave idempotente en PostgreSQL; reconciliar cuando el proveedor vuelva | Persistir eventos en cola; consumidor consulta o cobra de forma idempotente y confirma estados |
| Cómo cumple E2 | Evita perder el estado incluso al reiniciar la API; permite recuperar tras 15 min y medir el plazo | Conserva mensajes hasta que el consumidor pueda procesarlos; permite recuperación desacoplada |
| Costo de desarrollo | Menor; mantiene infraestructura existente, pero requiere migración de BD y pruebas | Mayor; contratos de cola, consumidor, reentregas, monitoreo y operación |
| Costo de operación | Incremento en consultas/almacenamiento y vigilancia del conciliador | Broker, telemetría, DLQ y mantenimiento; costo monetario sujeto a cotización |
| Riesgos | Doble ejecución entre réplicas; contención de BD; proveedor sin consulta/idempotencia | Duplicación de mensajes; mayor complejidad; nueva dependencia operativa |
| Restricciones | Compatible con monolito; viable como iteración de alcance acotado | Puede mantenerse monolito, pero infraestructura extra exige justificación |

### Decisión propuesta

Elegir **A**, con PostgreSQL como fuente duradera de estados y una conciliación controlada por el monolito. La selección es condicional a comprobar que el proveedor permite consultar una transacción o usar una clave idempotente; si no lo permite, la garantía de «sin cobro duplicado» no es demostrable.

### Riesgos y mitigaciones

- Dos réplicas ejecutan el mismo trabajo: reclamar intentos con bloqueo/lease transaccional y clave idempotente estable.
- Se pierde la respuesta después del cobro: consultar al proveedor **antes** de volver a cobrar.
- La pasarela continúa caída: conservar el estado y alertar; el SLA de 30 min empieza cuando la pasarela se recupera.
- Saturación de PostgreSQL: índices, lotes pequeños, backoff y métricas de cola pendiente.
- Pago rechazado: estado RECHAZADO, nunca CONFIRMADO.

### Evidencia necesaria

Ejecutar una prueba de concepto con pasarela falsa y reloj simulado; validar que reconcilia pagos confirmados sin duplicar cargos. La prueba no representa disponibilidad real de infraestructura.
