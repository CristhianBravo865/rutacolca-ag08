
## 2. Escenario completo E2 — Disponibilidad

| Parte | Definición de RutaColca |
|---|---|
| Fuente | Fallo temporal o falta de respuesta del proveedor externo de pagos. |
| Estímulo | La pasarela deja de responder durante 15 minutos mientras existen reservas con intento de pago o resultado desconocido. |
| Artefacto | API del monolito, módulo de pagos/reservas, adaptador PasarelaPago y persistencia PostgreSQL. |
| Entorno | Producción en temporada alta; dos réplicas de API, HTTPS síncrono con el proveedor, demanda elevada. |
| Respuesta | Registrar de forma duradera las reservas y el estado del intento, no confirmar pagos inciertos, y reconciliar/reintentar de forma idempotente después de la recuperación. |
| Medida de respuesta | Cero reservas ya pagadas perdidas; todas las reservas pendientes conciliables se confirman dentro de los 30 minutos posteriores a la recuperación del proveedor, sin cobros duplicados. |

### Alcance del objetivo

- «Pagada» significa que el proveedor confirma el pago, no que el cliente pulsó «Pagar».
- Una respuesta perdida puede ocultar un cobro exitoso: antes de repetir una operación se consulta el estado de la misma clave idempotente.
- Las reservas no pagadas o rechazadas permanecen diferenciadas; no se declaran confirmadas falsamente.
- Es una especificación de aceptación; la prueba de concepto representa el mecanismo, no demuestra una garantía operativa en producción.
