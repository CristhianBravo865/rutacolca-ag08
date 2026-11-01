# AG-10 — Bitácora de uso de IA

## Alcance y criterio

Esta bitácora corresponde al escenario **E2 — Disponibilidad** y documenta el uso de IA en la etapa de validación: la evaluación cruzada al estilo ATAM y la prueba de concepto en Java.

Se aplicó el criterio de la consigna: **la IA propone, el equipo decide y verifica**. Ninguna sugerencia se incorporó sin revisarla contra el escenario, el ADR-003 y las restricciones del caso (monolito modular, Java 21, PostgreSQL 16). En los prompts no se incluyeron credenciales ni datos personales.

## Prompts P1–P5 de la consigna

| Prompt | Propósito | Responsable | Entrada | Sugerencias aceptadas | Sugerencias corregidas o rechazadas | Verificación |
|---|---|---|---|---|---|---|
| P1 | Cuestionar la priorización del árbol de utilidad | Fuera del alcance de esta etapa | — | — | — | — |
| P2 | Iteración de ADD con dos alternativas | Fuera del alcance de esta etapa | — | — | — | — |
| P3 | Revisión del ADR | Fuera del alcance de esta etapa | — | — | — | — |
| P4 | Evaluación ATAM del diseño de E3 | Cristhian Bravo | Se adaptó el prompt para elaborar una **guía de evaluación** del escenario E3, con base en los cinco escenarios y el ADR-003 (detalle en V2). | Ver V2. | Ver V2. | Ver V2. |
| P5 | Cambios en `workspace.dsl` | Fuera del alcance de esta etapa | — | — | — | — |

## Detalle del uso de IA en la etapa de validación

Herramienta: Claude Code (modelo Claude Opus 5.5). Fecha: 01/11/2026. Responsable y verificador: Cristhian Bravo.

| ID | Propósito | Entrada | Sugerencias aceptadas | Sugerencias corregidas o acotadas | Verificación realizada |
|---|---|---|---|---|---|
| V1 | Implementar la prueba de concepto de la táctica elegida para E2 | Diseño de la POC (`PagoResiliente` y su prueba) y estados definidos en el ADR-003. | Modelo de estados `PENDIENTE`, `INCIERTO`, `CONFIRMADO` y `RECHAZADO`; consulta del estado del pago antes de cada cobro; clave idempotente por reserva; pasarela simulada en memoria. | Se fijó la compilación con `--release 21` para asegurar compatibilidad con la versión aprobada en el ADR-001. Se delimitó el alcance: la POC demuestra la táctica, no la disponibilidad en producción. | Compilación con `javac` y ejecución con `java`; las tres comprobaciones pasan (salida abajo). |
| V2 | Preparar la evaluación cruzada del escenario E3 | Escenarios E1–E5 de la consigna, ADR-003 y regla de intercambio E2 → E3. | Guía de riesgos, puntos de sensibilidad y trade-offs a observar en un diseño de E3 (autorización por objeto, auditoría, impacto en E1 y E2); seis preguntas para el grupo; observaciones sobre el ADR-003. | Se orientó la respuesta a criterios de observación y preguntas, sin atribuir hallazgos a un diseño que no fue analizado. | Contraste de cada punto con la Tabla 4 y el Anexo A de la consigna, y con el riesgo OWASP API1:2023. |

## Evidencia de verificación

Ejecución de la prueba de concepto (01/11/2026 · Windows 11 · OpenJDK 25.0.4.1 compilando con `--release 21`):

```text
> javac --release 21 -d %TEMP%\rutacolca-ag10-clases src/ag10/PagoResiliente.java src/ag10/PagoResilienteTest.java
javac exit: 0
> java -cp %TEMP%\rutacolca-ag10-clases PagoResilienteTest
OK - 3 escenarios: caida, recuperacion e idempotencia
java exit: 0
```

- [x] Las sugerencias de la IA se contrastaron con el escenario E2 y con la restricción del monolito modular; la POC no añade Maven, Gradle ni dependencias externas.
- [x] La POC se compiló y ejecutó, y se conserva su salida real.
- [x] Los estados de la POC coinciden con los del ADR-003.
- [x] La evaluación cruzada de E3 incluye riesgos, puntos de sensibilidad, trade-offs y preguntas.

## Decisiones del equipo en esta etapa

- **Alcance de la POC.** Usa almacenamiento en memoria (`HashMap`) en lugar de PostgreSQL y no cubre reinicios ni concurrencia entre las dos réplicas de la API. Se presenta como evidencia de la táctica (estado incierto, consulta previa y clave idempotente), no como implementación de persistencia.
- **Enfoque de la evaluación de E3.** Se formula como criterios de observación y preguntas al grupo, para centrar la revisión en lo que el diseño de E3 debe demostrar frente a los cinco escenarios.
