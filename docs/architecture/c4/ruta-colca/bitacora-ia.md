# E7 · Bitácora de uso de IA (Paso 10)

Responsable de la bitácora: _(vocero)_

Reglas del grupo: la IA propone, el equipo decide y verifica. No se pegan datos personales, credenciales ni datos reales de agencias o turistas en los prompts.

**Advertencia del equipo:** no marcar propuestas como aceptadas ni pruebas como ejecutadas antes de verificarlas. Registrar correcciones reales, nombres de integrantes y prompts posteriores.

## Cómo leer esta bitácora

- Hubo **un solo prompt inicial real** (fila 1). P1 a P8 **no son ocho prompts separados**: son los objetivos que la IA cubrió en esa misma generación (filas 1.1 a 1.8). La columna «Prompt» muestra el objetivo y la propuesta recibida tal como estaban en el registro original del equipo (ver el anexo).
- Para cada fila se conserva el estado original («Decisión del equipo» y «Verificador»). Nada está aceptado ni validado.
- Si en «Qué se rechazó o corrigió» aparece una **corrección propuesta**, esta viene de la revisión del modelo (fila 2). Es un hallazgo y todavía no es una decisión del grupo; el detalle está en `revision-cruzada.md`.
- `structurizr.sh validate` **no se ha ejecutado** todavía.

## Registro

| N.º | Fecha | Prompt | Qué se aceptó | Qué se rechazó o corrigió | Responsable |
|-----|-------|--------|---------------|---------------------------|-------------|
| 1 | PENDIENTE: confirmar (los commits del modelo son del 20/10/2026) | **Prompt inicial real, textual:** «Somos un grupo de tres, redactor dsl, revisor y vocero estan tomados, realiza la modelacion y todo listo para que nosotros empecemos a trabajar». Generó las propuestas 1.1 a 1.8. | PENDIENTE: verificar | PENDIENTE: verificar | PENDIENTE: nombre del integrante que lanzó el prompt |
| 1.1 | (igual que 1) | **P1 · Objetivo:** «Clasificar personas, sistemas y contenedores». **Propuesta recibida:** «Inventario C4 en inventario.md». | PENDIENTE: verificar (decisión original: «Pendiente de revisar»; verificador: «Pendiente») | Corrección propuesta (hallazgo 12): usar en el inventario el mismo nombre que en el DSL («API de negocio») y marcar el almacén local como Parte B. La decisión sobre el guía (persona que recibe por WhatsApp) es coherente con `whatsapp -> guia`, pero **no** con `ruta -> guia` (ver 1.2). Resto PENDIENTE: verificar | PENDIENTE: nombre del integrante |
| 1.2 | (igual que 1) | **P2 · Objetivo:** «Modelar contexto y relaciones». **Propuesta recibida:** «Contexto en workspace.dsl». | PENDIENTE: verificar (decisión original: «Pendiente de revisar»; verificador: «Pendiente») | Corrección propuesta (hallazgo 1), regla «no inventar relaciones; el guía recibe de WhatsApp, no de RutaColca»: quitar `ruta -> guia`. Hallazgo 10, regla «sin jerga en el nivel de contexto»: quitar «API HTTPS» de la descripción de AUTOCOLCA. Resto PENDIENTE: verificar | PENDIENTE: nombre del integrante |
| 1.3 | (igual que 1) | **P3 · Objetivo:** «Modelar contenedores del ADR-001». **Propuesta recibida:** «Contenedores en workspace.dsl». | PENDIENTE: verificar (decisión original: «Pendiente de revisar»; verificador: «Pendiente») | Corrección propuesta (hallazgo 7), regla «protocolo consistente entre contenedores»: `api -> pagos` usa «HTTPS» y no «JSON/HTTPS». Hallazgo 9, regla «tipos de elemento claros»: la base de datos no tiene forma de cilindro. Hallazgo 14 (no verificado): el administrador usa el portal de agencias. Resto PENDIENTE: verificar | PENDIENTE: nombre del integrante |
| 1.4 | (igual que 1) | **P4 · Objetivo:** «Modelar reserva y pago». **Propuesta recibida:** «Vista Dinamico en workspace.dsl». | PENDIENTE: verificar (decisión original: «Pendiente de revisar»; verificador: «Pendiente») | Observación no verificada (hallazgo 13): el cupo se actualiza recién después del cobro; hay que confirmarlo con la HU-02. Resto PENDIENTE: verificar | PENDIENTE: nombre del integrante |
| 1.5 | (igual que 1) | **P5 · Objetivo:** «Auditar con checklist C4». **Propuesta recibida:** «Pendiente de revisión cruzada real». | PENDIENTE: verificar (decisión original: «Pendiente»; verificador: «Pendiente») | PENDIENTE: verificar. La revisión cruzada real con otro grupo todavía no se hizo. | PENDIENTE: nombre del integrante |
| 1.6 | (igual que 1) | **P6 · Objetivo:** «Explicar contexto a gerente». **Propuesta recibida:** «Borrador en explicacion.md». | PENDIENTE: verificar (decisión original: «Pendiente de adaptar»; verificador: «Pendiente»). Nota: ese borrador **no está** en el repositorio (`explicacion.md` solo tenía la plantilla). | PENDIENTE: verificar | PENDIENTE: nombre del integrante |
| 1.7 | (igual que 1) | **P7 · Objetivo (Parte B):** «Proponer despliegue». **Propuesta recibida:** «Produccion en workspace.dsl». | PENDIENTE: verificar (decisión original: «Pendiente de revisar»; verificador: «Pendiente») | Corrección propuesta (hallazgo 6), regla «cada elemento del diagrama se relaciona; las relaciones tienen protocolo»: el balanceador no tiene relaciones con las réplicas de la API. Cumple «containerInstance sin contenedores nuevos» y «Docker solo como infraestructura». Resto PENDIENTE: verificar | PENDIENTE: nombre del integrante |
| 1.8 | (igual que 1) | **P8 · Objetivo (Parte B):** «Evaluar modo sin conexión». **Propuesta recibida:** «ADR-002 y ContenedoresReto». | PENDIENTE: verificar (decisión original: «Pendiente de revisar»; verificador: «Pendiente») | Corrección propuesta (hallazgo 2): ADR-002 vacío, solo está la plantilla. Hallazgo 3, regla «relaciones unidireccionales»: quitar `local -> portal`. Hallazgo 4: la vista base ya muestra «sincroniza». Hallazgo 5, regla «solo tecnologías del ADR-001 o de un ADR registrado»: IndexedDB no tiene justificación escrita. Resto PENDIENTE: verificar | PENDIENTE: nombre del integrante |
| 2 | 20/10/2026 | P5 · Revisión del modelo completo (`inventario.md`, `workspace.dsl`, `ADR-002`) con el Anexo A y las reglas C4 del enunciado (Claude Code, solo lectura). Resultado: 14 hallazgos en `revision-cruzada.md`. `validate` no se ejecutó porque la herramienta no estaba disponible. | PENDIENTE: completar (vocero) | PENDIENTE: completar (vocero) | PENDIENTE: nombre del vocero |
| 3 | 20/10/2026 | P6 · Propuesta de explicación del contexto para la gerente de una agencia de Chivay (200 a 250 palabras, basada en la vista `Contexto`), con revisión de jerga y de niveles mezclados (Claude Code). Queda en `explicacion.md` como borrador de IA. | PENDIENTE: completar (vocero) | PENDIENTE: completar (vocero) | PENDIENTE: nombre del vocero |

> En «Qué se rechazó o corrigió» anotar la regla de C4 usada (por ejemplo: «Docker no es un contenedor C4», «relación sin protocolo», «sistema inventado que no está en el caso»). Sirve para la pregunta 3 de la socialización.

## Anexo · Registro original del equipo (copiado sin cambios)

Es la primera bitácora que pasó un integrante. Se conserva como evidencia de lo que se registró en el momento.

| ID | Prompt/objetivo | Propuesta recibida | Decisión del equipo | Verificador |
|---|---|---|---|---|
| P1 | Clasificar personas, sistemas y contenedores | Inventario C4 en inventario.md | Pendiente de revisar | Pendiente |
| P2 | Modelar contexto y relaciones | Contexto en workspace.dsl | Pendiente de revisar | Pendiente |
| P3 | Modelar contenedores del ADR-001 | Contenedores en workspace.dsl | Pendiente de revisar | Pendiente |
| P4 | Modelar reserva y pago | Vista Dinamico en workspace.dsl | Pendiente de revisar | Pendiente |
| P5 | Auditar con checklist C4 | Pendiente de revisión cruzada real | Pendiente | Pendiente |
| P6 | Explicar contexto a gerente | Borrador en explicacion.md | Pendiente de adaptar | Pendiente |
| P7 | Proponer despliegue | Produccion en workspace.dsl | Pendiente de revisar | Pendiente |
| P8 | Evaluar modo sin conexión | ADR-002 y ContenedoresReto | Pendiente de revisar | Pendiente |

**Prompt inicial real:** «Somos un grupo de tres, redactor dsl, revisor y vocero estan tomados, realiza la modelacion y todo listo para que nosotros empecemos a trabajar».

**Advertencia:** no marcar propuestas como aceptadas ni pruebas como ejecutadas antes de verificarlas. Registrar correcciones reales, nombres de integrantes y prompts posteriores.
