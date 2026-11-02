# AG-10 — Árbol de utilidad y escenario E2

- Actividad: Diseño de la arquitectura de RutaColca, temporada alta.
- Escenario asignado: E2, disponibilidad de pagos.
- Base técnica: monolito modular Java 21/Spring Boot, PostgreSQL 16, dos réplicas de API; pasarela de pagos síncrona por HTTPS.
- Estado del análisis AG-09: aprobado por el equipo (el encabezado anterior no refleja la aprobación).

## 1. Árbol de utilidad

Escala: A = alta, M = media, B = baja. Son valoraciones justificadas del equipo para AG-10, no mediciones de producción.

| Escenario | Importancia | Dificultad | Justificación |
|---|---|---|---|
| E1 Rendimiento | A | A | Diez veces más reservas en temporada alta; el p95 de 1,5 s frente a 2000 consultas simultáneas exige prueba de carga y ajustes. |
| E2 Disponibilidad | A | A | La pasarela HTTPS síncrona puede fallar durante 15 min; sin persistencia de estados ni conciliación se desconoce el resultado de un cobro. |
| E3 Seguridad | A | M | La edición de tours requiere autorización a nivel de objeto y auditoría por agencia; puede instrumentarse dentro de la API existente. |
| E4 Modificabilidad | M | M | El análisis AG-09 aprobó una interfaz común PasarelaPago y Adapter cuando las API difieran; PayPal debe aislarse del dominio. |
| E5 Interoperabilidad | A | A | La caída de AUTOCOLCA obliga a conservar validaciones pendientes sin cobrar boletos inválidos; exige controlar estados y recuperación. |

E2 recibe prioridad (A, A) porque un resultado de pago incierto puede implicar pérdida de ventas, reservas sin confirmar o cobros duplicados. Las calificaciones de los otros escenarios deberán contrastarse al evaluar la decisión final.
