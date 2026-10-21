# E3 · Explicación del contexto para una persona no técnica (Paso 6)

- **Vocero:** _(nombre)_
- **Público:** gerente de una agencia de turismo de Chivay
- **Duración:** unos 2 minutos

## Explicación (versión final del vocero)

_(Escribir aquí con palabras propias. Debe responder: qué hace RutaColca, quién lo usa y con qué servicios se conecta. Sin siglas ni términos técnicos: API, DSL, HTTPS, base de datos, contenedor.)_

## Borrador de IA (P6) · BORRADOR DE IA, el vocero lo reescribe

> No es la versión final. Se basa en la vista `Contexto` de `workspace.dsl`. Hay una diferencia a propósito: el diagrama actual tiene la relación RutaColca → guía y el borrador solo dice que el guía recibe la información por WhatsApp (ver hallazgo 1 de `revision-cruzada.md`). Tiene 247 palabras (contadas con `wc -w`); hay que cronometrarlo en voz alta.

Buenos días. En dos minutos le voy a contar qué es RutaColca y cómo encaja en el trabajo de su agencia.

RutaColca es una plataforma que reúne en un solo lugar a las agencias del consorcio del valle del Colca. Ahí cada agencia publica sus tours, como el Colca clásico de dos días, la Cruz del Cóndor o el trekking, con sus fechas y los cupos que tiene. Los turistas los encuentran, reservan su lugar y pagan por internet, sin tener que llamar ni ir a la oficina.

¿Quiénes la usan? Primero, el turista, que busca, reserva y paga. Segundo, el personal de su agencia, que publica los tours y registra las reservas. Tercero, un administrador del consorcio, que aprueba qué agencias pueden vender y revisa cuánto se ha vendido.

Los guías no entran a la plataforma. Reciben por WhatsApp el itinerario y la lista de su grupo, como ya están acostumbrados.

Para funcionar, RutaColca se apoya en tres servicios de afuera. El primero es el servicio de cobros, que funciona como el POS de una tienda: cobra con tarjeta o billetera móvil, y RutaColca nunca guarda los datos de la tarjeta. El segundo es WhatsApp, que lleva los mensajes a los guías. El tercero es AUTOCOLCA: antes de confirmar una reserva, RutaColca revisa con AUTOCOLCA que el boleto turístico del visitante sea válido.

En resumen: su agencia publica, el turista reserva y paga, y RutaColca se encarga de cobrar, revisar el boleto y avisar al guía.

## Lista de control antes de presentar

Revisada sobre el **borrador de IA** de arriba. Hay que volver a revisarla con la versión final del vocero.

- [x] Menciona qué hace RutaColca para la agencia (publicar tours con fechas y cupos; reservas y pagos en línea).
- [x] Menciona a todas las personas que la usan (turista, personal de agencia, administrador) y qué pasa con el guía (no la usa; recibe por WhatsApp).
- [x] Menciona los tres servicios con los que se conecta (cobros, WhatsApp, AUTOCOLCA).
- [x] No usa siglas ni jerga técnica. «POS» se deja como comparación porque la gerente la conoce. Si se prefiere, cambiar por «la maquinita de tarjetas».
- [x] No habla de piezas internas (aplicación web, servidor, base de datos): eso es nivel de contenedores, no de contexto.
- [ ] Se practicó en voz alta y dura menos de 2 minutos. _(Pendiente: lo hace el vocero.)_

## Cambios respecto al borrador de la IA (si se usó el prompt P6)

> El borrador P6 de la generación inicial no está en el repositorio, así que no se puede comparar con él. Esta tabla la llena el vocero comparando su versión final con el borrador de arriba.

| Qué decía el borrador | Qué cambiamos | Por qué |
|---|---|---|
| | | |
