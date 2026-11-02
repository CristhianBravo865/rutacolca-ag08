# ADR-003: Conciliar pagos con estados persistentes e idempotencia

- Estado: **Aceptado por el grupo para AG-10** (confirmar la revisión en el PR).
- Fecha: 30/10/2026.
- Escenario: E2 — Disponibilidad.
- Relacionado con: ADR-001 (monolito modular), ADR-002 (trabajo sin conexión) y análisis AG-09 aprobado.

## Contexto

En temporada alta, la pasarela HTTPS síncrona puede dejar de responder durante 15 minutos. RutaColca debe evitar la pérdida de reservas efectivamente pagadas y confirmar pendientes en hasta 30 minutos después de recuperar la conexión. Un timeout no demuestra que un pago no ocurrió: el proveedor podría haber cobrado antes de perderse la respuesta. Existen dos réplicas de API y PostgreSQL 16, y se debe conservar la arquitectura de monolito modular.

## Alternativas consideradas

- **A — Elegida:** persistir reservas e intentos en PostgreSQL y reconciliar en una tarea controlada del monolito usando consulta de estado, claves idempotentes, timeout y retry acotado.
- **B — Descartada:** broker/cola externa con consumidor asíncrono idempotente. Ofrece desacoplamiento, pero incrementa infraestructura, desarrollo y operación para esta iteración.

## Decisión

Mantener en la API los módulos de reservas/pagos y el contrato `PasarelaPago` ya previsto en el análisis AG-09; no introducir un servicio externo propio ni una Factory obligatoria. Al iniciar un pago, persistir el intento con clave idempotente estable y estado PENDIENTE. Ante resultado incierto, registrar INCIERTO y **no** declarar CONFIRMADO. Al recuperarse la pasarela, consultar el estado del proveedor por la misma clave; confirmar solo pagos comprobados o completar operaciones aún no cobradas con la misma clave. Coordinar el conciliador entre las dos réplicas de API para que una operación no se procese simultáneamente de manera insegura.

## Consecuencias positivas

- Estado durable de intentos, auditable y recuperable tras reinicios.
- Evita volver a cobrar sin consultar el estado de transacciones inciertas.
- Aprovecha PostgreSQL y el monolito existente, sin broker adicional.
- Permite medir la edad de los pendientes y el tiempo de reconciliación después de la recuperación.

## Consecuencias negativas y mitigaciones

- Mayor carga y consultas en PostgreSQL: índices, lotes limitados, monitorización y backoff.
- Coordinación compleja entre las dos réplicas: bloqueo/lease transaccional y pruebas de concurrencia.
- Dependencia de capacidad de consulta/idempotencia del proveedor: validar contrato real antes de producción; sin ella no prometer eliminación de dobles cargos.
- Retraso en la confirmación de reservas: mostrar estado pendiente al usuario y emitir confirmación solo tras resultado válido.
- Posible impacto en E1 por trabajos de recuperación: ejecutar por lotes y limitar tasa.

## Verificación

- Simulación de caída de 15 min y recuperación.
- Cero reservas con pago confirmado omitidas en el repositorio.
- No duplicar cargos para una misma clave idempotente ante reintentos.
- Confirmar operaciones pagadas dentro de 30 min desde la recuperación.
- Registrar métricas/alertas de pendientes, reintentos y vencimiento del objetivo.

## Cambios en C4

Añadir componentes internos de pagos y conciliación dentro de la API; conservar relaciones API–PostgreSQL y API–pasarela; añadir vista dinámica `PagoConPasarelaCaida` y actualizar las vistas pertinentes, sin rehacer AG-08.
