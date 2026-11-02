
## 3. Protocolo de verificación E2

1. Crear un conjunto conocido de reservas identificadas por ID y clave idempotente única.
2. Simular 15 minutos de indisponibilidad de pasarela; registrar los estados PENDIENTE, INCIERTO o CONFIRMADO de forma persistente.
3. Simular una respuesta de red perdida tras haberse producido un pago; reconciliar por clave idempotente.
4. Recuperar la pasarela y ejecutar reconciliaciones repetidas sin cobrar dos veces.
5. Medir el tiempo transcurrido desde el restablecimiento hasta la confirmación de cada pago efectivamente realizado: objetivo ≤ 30 minutos.
6. Verificar que ninguna reserva con pago confirmado desaparezca y que las no pagadas no queden marcadas como pagadas.

### Evidencias a conservar

- Resultado de las pruebas automatizadas del integrante responsable de la prueba de concepto.
- Diagrama dinámico de pago fallido y recuperación, validado por Structurizr.
- ADR que justifica la alternativa seleccionada y reconoce sus riesgos.

### Dependencias

Enviar al arquitecto responsable de `alternativas.md` esta medida exacta antes de aprobar la alternativa. No cambiar el objetivo de la guía para facilitar la prueba.
