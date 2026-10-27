# Evaluación crítica de IA: AG-09

**Responsable:** [tu nombre] · **Herramienta:** Antigravity (Fases 0–4: Gemini; consultas de evaluación: Claude Opus 5.5) · **Fecha:** 2026-10-27
**Evidencias:** `docs/ag09/evidencias-ia/` *(pendiente: guardar capturas o exportación del chat de ambas consultas)*

## 1. Metodología
- Se enviaron los cinco escenarios con su contexto real, sin nombrar patrones.
- Se solicitó alternativas, principio de diseño y opción sin patrón.
- Se hizo una segunda consulta sobre complejidad innecesaria para un equipo de 3–4 estudiantes.
- **Limitación:** las consultas se hicieron en la **misma conversación** donde ya se habían elegido los patrones (Fases 1–4). La IA tenía ese contexto, así que la consulta "sin nombrar patrones" **no fue independiente** y sus respuestas pueden estar sesgadas hacia las decisiones previas.

## 2. Contraste IA vs. análisis del equipo

| # | Propuesta de la IA | Decisión del equipo | Veredicto | Motivo |
|---|---|---|---|---|
| 1 | Ninguno: interfaz `PasarelaPago` + inyección de dependencias. Strategy o Adapter + Factory solo si hay SDKs distintos. En la 2.ª consulta, aún más simple: una sola clase `PasarelaPagoClient`. | Ninguno (interfaz `PasarelaPago` + inyección de dependencias). | **Aceptado** | `workspace.dsl` modela una única `pasarela`. Coincide con el análisis de paternite de la Fase 2. |
| 2 | 1.ª consulta: Strategy, condicionado a que cada regla tenga lógica propia. 2.ª consulta: descartarlo y usar un `enum TipoTarifa` o una tabla de tarifas en `ruta.db`. | Strategy (`EstrategiaPrecio` + 3 clases concretas). | **Aceptado parcialmente** | Se mantiene Strategy para modelar el patrón exigido por la rúbrica. Queda abierto si las reglas son solo porcentajes; en ese caso la IA tendría razón y bastaría el `enum`. |
| 3 | 1.ª consulta: Observer con eventos de Spring (`@TransactionalEventListener(AFTER_COMMIT)`). 2.ª consulta: descartarlo y usar una sola clase `NotificadorReserva`. Advirtió que `workspace.dsl` solo modela WhatsApp hacia el guía. | Observer conceptual con `PublicadorReservas` manual y 3 observadores que envían por `WhatsAppBusiness`. | **Corregido** | Se mantiene Observer a nivel de diseño. En la implementación se recomienda usar los eventos de Spring en lugar de una lista manual. Falta confirmar el canal para turista y agencia. |
| 4 | Adapter (`AutocolcaAdapter` implementa `ValidadorBoleto`). Lo mantuvo también en la 2.ª consulta por su bajo costo y porque permite probar con un validador falso. | Adapter. | **Aceptado** | El enunciado describe justo el problema que resuelve Adapter: una interfaz incompatible que no se puede modificar. |
| 5 | Ninguno: índice + consulta directa. `@Cacheable` solo si una medición lo justifica. Advirtió sobre las 2 réplicas de `ruta.api` y propuso verificar el cupo con `SELECT … FOR UPDATE`. | Ninguno. | **Aceptado** | Coincide con la Fase 2. El bloqueo transaccional al reservar es un aporte nuevo de la IA y se debe evaluar. |

## 3. Recomendación de la IA no adoptada
- **Qué propuso:** en la 2.ª consulta recomendó descartar **Strategy** (escenario 2) y **Observer** (escenario 3) por complejidad innecesaria. Para el 2 propuso un `enum` con factor y para el 3 una clase `NotificadorReserva` con llamadas directas. También mencionó *outbox* y `@TransactionalEventListener`, que no se adoptaron.
- **Por qué no se adoptó:** la actividad pide diagramar dos escenarios con patrón. Además, las tres reglas de precio y los tres destinatarios son variantes reales del caso.
- **Qué se hizo:** se mantuvieron Strategy y Observer en la tabla y en los diagramas. El *outbox* y `@Cacheable` quedaron como alternativas no implementadas.
- **Cuándo se reconsideraría:**
  - Strategy deja de convenir si las reglas son solo porcentajes.
  - Observer pasa a implementarse con eventos de Spring si aparecen más destinatarios o canales.
  - El *outbox* se justifica si perder un aviso tiene un costo real.

## 4. Hallazgos adicionales
- **Sobreaplicación:** en la Fase 1 la IA propuso inicialmente **Factory** para los pagos, por asociación con la frase "tarjeta, Yape y PayPal". Se corrigió a "ninguno" en la Fase 2.
- **Sintaxis PlantUML:** al compactar `escenario3-observer.puml` a menos de 30 líneas, la IA escribió clases con miembros en una sola línea (líneas 14–16). **Verificar** que el archivo final esté corregido y renderice: `bitacora-ia.md` dice que se corrigió a mano, pero en la última revisión de la IA seguía igual.
- **Supuestos no verificados:**
  - La IA afirmó que "cientos de consultas son poca carga para PostgreSQL" sin haberlo medido.
  - En `bitacora-ia.md` usó Culqi y Niubiz como ejemplos de pasarela, aunque no aparecen en `workspace.dsl`.
  - En la Fase 0 asumió que el proyecto "no tiene código aún" porque no existe `src/`.
- **Diferencias entre diagramas y propuesta:**
  - `escenario3-observer.puml` asume WhatsApp para los tres destinatarios, pero `workspace.dsl` solo modela `whatsapp -> guia`.
  - Ese diagrama usa un sujeto manual (`List<ObservadorReserva>`), mientras que la IA recomienda los eventos de Spring.
  - `escenario2-strategy.puml` modela Strategy completo, mientras que la 2.ª consulta sugiere un `enum`.

## 5. Conclusión
La IA ayudó a identificar los problemas de diseño, a dar alternativas realistas (eventos de Spring, tarifas como datos, bloqueo transaccional) y a frenar la paternite en los escenarios 1 y 5. Hubo que corregir una sobreaplicación inicial (Factory), un error de sintaxis en PlantUML y supuestos no verificados. Además, como las consultas no fueron independientes, sus respuestas finales pueden reflejar las decisiones previas y no un análisis desde cero.
