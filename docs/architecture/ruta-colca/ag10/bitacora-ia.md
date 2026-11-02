# AG-10 — Bitácora de uso de IA

## Alcance y criterio

Esta bitácora corresponde al escenario **E2 — Disponibilidad** y registra el uso de los prompts P1 a P5 de la consigna y de la IA en la prueba de concepto.

Se aplicó el criterio de la consigna: **la IA propone, el equipo decide y verifica**. En los prompts no se incluyeron credenciales ni datos personales.

**Cómo se ejecutaron.** P1, P2, P3 y P5 se ejecutaron el 01/11/2026 como **revisión de los entregables ya redactados**. Por eso sus resultados no explican cómo se elaboraron esos documentos; el único prompt de elaboración disponible se registra en la sección siguiente. Una sugerencia figura como aceptada si se comprobó en el repositorio que señala un punto real; **aceptada no significa aplicada**. Al cierre de esta revisión, ninguna se ha aplicado en los entregables.

Herramienta: Claude Code (modelo Claude Opus 5.5). Ejecutó: Cristhian Bravo. El contraste de las sugerencias con el repositorio se realizó con la misma herramienta.

## Prompt usado durante la elaboración de las alternativas y el ADR

**Ejecutó:** Fernando Luque. **Herramienta:** ChatGPT. **Fecha:** sin registro. **Relacionado con:** P2 y `ADR-003` (no equivale a P3, que pide revisar un ADR ya escrito).

```text
Actúa como arquitecto de software especializado en ADD 3.0 y decisiones arquitectónicas (ADR).
Contexto: RutaColca utiliza un monolito modular con Java 21, Spring Boot y PostgreSQL 16.
Escenario E2: La pasarela de pagos deja de responder durante 15 minutos.
Objetivo: Evitar pérdidas de reservas pagadas y confirmar pagos pendientes en un máximo de 30 minutos tras la recuperación.

1. Aplica los pasos de ADD para identificar los componentes, tácticas y patrones necesarios.
2. Propón dos alternativas: conciliación con PostgreSQL y procesamiento asíncrono mediante broker.
3. Compara ambas alternativas considerando costos, beneficios, riesgos y restricciones.
4. Selecciona y justifica la alternativa más viable para un equipo de 4 desarrolladores y un plazo de 3 semanas.
5. Redacta el ADR-003 con contexto, alternativas, decisión, consecuencias y trade-offs.
   Restricción: Mantén el monolito modular y evita infraestructura adicional innecesaria.
```

- **Respuesta de la IA, lo aceptado y lo corregido:** sin registro; solo se dispone del texto del prompt.
- **Observación de la revisión:** a diferencia de P2, el prompt indica de antemano las dos alternativas y no pide estimar el costo de la infraestructura nueva. Esto coincide con que `alternativas.md` deja el costo del broker «sujeto a cotización».

## Prompts P1–P5 de la consigna

| Prompt | Propósito y entrada | Responsable del entregable | Resultado de la IA | Aceptado | Corregido o rechazado, y por qué |
|---|---|---|---|---|---|
| P1 | Cuestionar la priorización. Entrada: sección 3 de la consigna y árbol de utilidad. | Giovani Mendoza | E1, E2 y E5 están en (A, A), pero no se explica por qué E2 tiene prioridad sobre los otros dos. La justificación de E1 habla de reservas y el escenario mide consultas de disponibilidad. Falta una línea base del p95 actual y el volumen de pagos pendientes durante 15 min. | Aclarar que E2 se trabaja por asignación de la consigna y alinear la justificación de E1 con su medida. Pendiente de aplicar en `utilidad-parte1.md`. | No se cambian las calificaciones: el prompt solo pide preguntas y observaciones. |
| P2 | Iteración ADD con dos alternativas. Entrada: drivers, escenario E2, arquitectura actual y `alternativas.md`. | Fernando Luque | Mantiene la alternativa A frente al broker. Advierte que completar después un cobro no iniciado requiere una autorización o token vigente, y el modelo indica que la base «no guarda datos de tarjetas». El costo del broker no está estimado. Sugiere un *circuit breaker*. | Registrar como riesgo la autorización del cobro diferido y estimar el costo de operación del broker. Pendiente de aplicar en `alternativas.md` y ADR-003. | *Circuit breaker* no adoptado en esta iteración: la medida de E2 se cubre con *timeout* y reintento acotado. **Limitación:** la IA ya conocía las alternativas, así que la comparación no fue independiente. |
| P3 | Revisar el ADR. Entrada: ADR-003 y escenario E2. | Fernando Luque | El ADR tiene contexto, decisión, alternativa descartada y consecuencias negativas. Son vagos «lotes limitados», «backoff» y «limitar tasa», sin valores. No define el período del conciliador. Omite el estado `RECHAZADO`, que sí aparece en `alternativas.md`. Mantiene la nota «confirmar la revisión en el PR». | Fijar período y tamaño de lote coherentes con ≤ 30 min, agregar `RECHAZADO` y actualizar la nota de estado. Pendiente de aplicar en ADR-003. | No se reescribe la decisión: el prompt lo prohíbe. |
| P4 | Evaluación ATAM de E3. Entrada: cinco escenarios y ADR-003. | Cristhian Bravo | Se adaptó el prompt para elaborar una **guía de evaluación**, porque no se analizó un ADR de E3 (detalle en V2). | Ver V2. | Ver V2. |
| P5 | Revisión de cambios en el modelo. Entrada: `workspace.dsl` de la rama `feature/ag10-c4` (commit `d326dec`) y ADR-003. | Diego Schreiber | Los componentes y la vista `PagoConPasarelaCaida` corresponden al ADR-003, y cada paso de la vista usa una relación existente. Queda una línea con tres comillas invertidas tras el bloque de componentes, que no es sintaxis DSL. La rama no incluye exportaciones. La vista no muestra que se informe al turista el estado pendiente. | Quitar esa línea, validar y exportar, y evaluar un paso que muestre el estado pendiente. Pendiente de aplicar en `feature/ag10-c4`. | Sin validar: no se ejecutó la CLI de Structurizr y la rama aún no está fusionada en `main`. |

## Uso de IA en la etapa de validación

Fecha: 01/11/2026. Responsable y verificador: Cristhian Bravo.

| ID | Propósito | Entrada | Sugerencias aceptadas | Sugerencias corregidas o acotadas | Verificación realizada |
|---|---|---|---|---|---|
| V1 | Implementar la prueba de concepto de la táctica elegida para E2 | Diseño de la POC (`PagoResiliente` y su prueba) y estados definidos para AG-10. | Modelo de estados; consulta del estado del pago antes de cada cobro; clave idempotente por reserva; pasarela simulada en memoria. | Se fijó la compilación con `--release 21` por compatibilidad con el ADR-001. Se delimitó el alcance: la POC demuestra la táctica, no la disponibilidad en producción. | Compilación con `javac` y ejecución con `java`; las comprobaciones pasan (salida abajo). |
| V2 | Preparar la evaluación cruzada del escenario E3 | Escenarios E1–E5 de la consigna, ADR-003 y regla de intercambio E2 → E3. | Guía de riesgos, puntos de sensibilidad y trade-offs a observar en un diseño de E3; seis preguntas para el grupo; observaciones sobre el ADR-003. | Se orientó la respuesta a criterios de observación y preguntas, sin atribuir hallazgos a un diseño que no fue analizado. | Contraste con la Tabla 4 y el Anexo A de la consigna, y con el riesgo OWASP API1:2023. |

## Evidencia de verificación

Ejecución de la prueba de concepto (01/11/2026 · Windows 11 · OpenJDK 25.0.4.1 compilando con `--release 21`):

```text
> javac --release 21 -d %TEMP%\rutacolca-ag10-clases src/ag10/PagoResiliente.java src/ag10/PagoResilienteTest.java
javac exit: 0
> java -cp %TEMP%\rutacolca-ag10-clases PagoResilienteTest
OK - 3 escenarios: caida, recuperacion e idempotencia
java exit: 0
```

- [x] Las sugerencias de la IA se contrastaron con los entregables, el escenario E2 y la restricción del monolito modular.
- [x] Se revisó la comparación de dos alternativas y no se adoptaron todas las sugerencias de la IA.
- [ ] Se verificó la sintaxis C4 con la CLI y se guardó su resultado real.
- [x] La POC se compiló y ejecutó, y se conserva su salida real.
- [x] Los estados `PENDIENTE`, `INCIERTO` y `CONFIRMADO` de la POC coinciden con ADR-003; `RECHAZADO` proviene de `alternativas.md` y la POC no ejercita ese caso.
- [x] La evaluación cruzada de E3 incluye riesgos, puntos de sensibilidad, trade-offs y preguntas.

## Decisiones del equipo en esta etapa

- **Alcance de la POC.** Usa almacenamiento en memoria (`HashMap`) en lugar de PostgreSQL y no cubre reinicios ni concurrencia entre las dos réplicas de la API. Se presenta como evidencia de la táctica (estado incierto, consulta previa y clave idempotente), no como implementación de persistencia.
- **Enfoque de la evaluación de E3.** Se formula como criterios de observación y preguntas al grupo, para centrar la revisión en lo que el diseño de E3 debe demostrar frente a los cinco escenarios.
