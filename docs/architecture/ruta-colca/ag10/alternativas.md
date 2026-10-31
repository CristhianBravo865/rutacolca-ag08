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
