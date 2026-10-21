# E7 · Bitácora de uso de IA (Paso 10)

Grupo sin número asignado · Asistente usado: Claude (Anthropic) · Responsable de la bitácora: Cristhian Matias Bravo Arredondo (vocero)

| Integrante | Rol Parte A |
|---|---|
| Fernando Gerson Luque Guevara | Modelador y revisor |
| Giovani Angel Mendoza Contreras | Redactor del DSL |
| Cristhian Matias Bravo Arredondo | Vocero |

Reglas del grupo: la IA propone, el equipo decide y verifica. No se pegan datos personales, credenciales ni datos reales de agencias o turistas en los prompts. No se marca nada como aceptado ni como ejecutado sin haberlo verificado.

## Cómo leer esta bitácora

- **Filas 1 a 1.8 · generación inicial.** Hubo **un solo prompt real**: la fila 1. P1 a P8 **no son ocho prompts separados**, sino los objetivos que la IA cubrió en esa misma respuesta. El responsable se identificó por la autoría de los commits de esa generación (PR #1).
- **Filas 2 a 7 · redactor del DSL.** Salen de su conversación con el asistente. Los prompts están resumidos, no copiados textualmente. Él verificó lo aceptado en esas filas.
- **Filas 8 y 9 · vocero.** Revisión del modelo (P5) y borrador de la explicación (P6).
- **Registros originales.** Están copiados sin cambios en los anexos A y B.

## Registro

| N.º | Fecha | Prompt | Qué se aceptó | Qué se rechazó o corrigió | Responsable |
|-----|-------|--------|---------------|---------------------------|-------------|
| 1 | 20/10/2026 | **Prompt inicial real, textual:** «Somos un grupo de tres, redactor dsl, revisor y vocero estan tomados, realiza la modelacion y todo listo para que nosotros empecemos a trabajar». Generó las propuestas 1.1 a 1.8. | El inventario (1.1), que sigue en el repositorio. | El `workspace.dsl` que generó se descartó entero (filas 1.2 a 1.4, 1.7 y 1.8) y se usó la versión del redactor (fila 7). | Fernando Gerson Luque Guevara |
| 1.1 | 20/10/2026 | **P1 · Objetivo:** «Clasificar personas, sistemas y contenedores». **Propuesta recibida:** inventario C4 en `inventario.md`. | Los 13 elementos y la decisión de que el guía es persona del contexto: no usa la plataforma y recibe la información por WhatsApp. El grupo la confirmó junto con los supuestos de la fila 3. | Se aceptaron dos correcciones de la revisión (fila 8). Hallazgo 10: marcar el almacén local como Parte B y quitar «API HTTPS» (regla: separar niveles y partes, sin jerga). Hallazgo 9: anotar que el administrador usa el portal de agencias. | Fernando Gerson Luque Guevara |
| 1.2 | 20/10/2026 | **P2 · Objetivo:** «Modelar contexto y relaciones». **Propuesta recibida:** contexto en `workspace.dsl`. | Nada; esta versión no quedó en el modelo final. | Se descartó (fila 7). Además, tenía la relación RutaColca → guía. Regla: el guía no usa el sistema; la relación correcta va de WhatsApp al guía. | Fernando Gerson Luque Guevara |
| 1.3 | 20/10/2026 | **P3 · Objetivo:** «Modelar contenedores del ADR-001». **Propuesta recibida:** contenedores en `workspace.dsl`. | Nada; esta versión no quedó en el modelo final. | Se descartó (fila 7). Además, usaba protocolos inconsistentes hacia la pasarela («HTTPS» frente a «JSON/HTTPS») y la base de datos no tenía forma de cilindro. | Fernando Gerson Luque Guevara |
| 1.4 | 20/10/2026 | **P4 · Objetivo:** «Modelar reserva y pago». **Propuesta recibida:** vista `Dinamico` en `workspace.dsl`. | Nada; esta versión no quedó en el modelo final. | Se descartó (fila 7). La vista final es la del redactor, con 6 pasos. | Fernando Gerson Luque Guevara |
| 1.5 | 20/10/2026 | **P5 · Objetivo:** «Auditar con checklist C4». **Propuesta recibida:** «Pendiente de revisión cruzada real». | Nada; no produjo ningún entregable. | Se reemplazó por la revisión de la fila 8. | Fernando Gerson Luque Guevara |
| 1.6 | 20/10/2026 | **P6 · Objetivo:** «Explicar contexto a gerente». **Propuesta recibida:** borrador en `explicacion.md`. | Nada; el borrador no se guardó en el repositorio (`explicacion.md` solo tenía la plantilla). | Se reemplazó por el borrador de la fila 9. | Fernando Gerson Luque Guevara |
| 1.7 | 20/10/2026 | **P7 · Objetivo (Parte B):** «Proponer despliegue». **Propuesta recibida:** `Produccion` en `workspace.dsl`. | Nada; esta versión no quedó en el modelo final. | Se descartó (fila 7). Además, el balanceador no tenía ninguna relación. Regla: todo elemento del diagrama se relaciona con algo. | Fernando Gerson Luque Guevara |
| 1.8 | 20/10/2026 | **P8 · Objetivo (Parte B):** «Evaluar modo sin conexión». **Propuesta recibida:** ADR-002 y `ContenedoresReto`. | Nada; esta versión no quedó en el modelo final. | Se descartó (fila 7). Además, tenía portal → almacén y almacén → portal. Regla: relaciones en un solo sentido; un almacén de datos no inicia acciones. El ADR-002 nunca se generó: el archivo sigue siendo la plantilla (hallazgo 1, aceptado). | Fernando Gerson Luque Guevara |
| 2 | 20/10/2026 | Estructura de trabajo del AG-08, si hacía falta trabajar en local y cómo organizar el repositorio. | Estructura de carpetas `docs/architecture/c4/ruta-colca/`, flujo por pasos y herramientas (Java, Structurizr CLI, PlantUML, Graphviz, Git). | Nada. Se contrastó con la Tabla 8 (entregables) del documento. | Giovani Angel Mendoza Contreras |
| 3 | 20/10/2026 | Borrador completo de `workspace.dsl` (contexto, contenedores, dinámico, despliegue y reto sin conexión) para el rol de redactor del DSL. | Personas, 4 contenedores del ADR-001, 3 externos, relaciones con verbo y protocolo, vista dinámica con 6 pasos, despliegue con 2 VM y balanceador. El grupo confirmó los 4 supuestos de la IA: el guía es persona, el boleto se valida antes de cobrar, el administrador usa el portal de agencias e IndexedDB es el almacén local. IndexedDB queda condicionado a que el ADR-002 lo justifique (hallazgo 5). | Ningún supuesto se rechazó. Las correcciones al DSL salieron de la revisión (fila 8). | Giovani Angel Mendoza Contreras |
| 4 | 20/10/2026 | Revisión de las capturas del visor web (contexto y contenedores) contra la lista del Anexo A. | Observaciones sobre la leyenda y sobre cómo distinguir los sistemas externos. | La IA sugirió quitar el protocolo «WhatsApp» de la flecha al guía. **No se aplicó** y se mantuvo. | Giovani Angel Mendoza Contreras |
| 5 | 20/10/2026 | Revisión de las 5 imágenes exportadas a PNG (C4-PlantUML). | Cambio en `workspace.dsl`: las descripciones de Pasarela de pagos, WhatsApp Business y AUTOCOLCA empiezan con «Sistema externo», porque la exportación a C4-PlantUML pinta todo del mismo azul. Lo aplicó la IA y el redactor lo verificó al regenerar los PNG. | Al principio no se aplicó la relación web → balanceador que sugirió la IA, con el argumento de que «duplicaría una deducción automática de Structurizr». En la revisión (fila 8, hallazgo 4) se comprobó que ese motivo no es correcto: la regla prohíbe crear contenedores nuevos en el despliegue, no relacionar instancias con nodos de infraestructura. **Se aceptó agregar la relación.** | Giovani Angel Mendoza Contreras |
| 6 | 20/10/2026 | Comandos para validar y exportar en Windows (CLI, `plantuml.jar`, Graphviz). Depuración de rutas, de la variable `RUTA`, de un archivo de imagen bloqueado y de un conflicto de Git. | Comandos de `validate`, `export` (c4plantuml y mermaid) y generación de PNG. El redactor los ejecutó y obtuvo `ERRORLEVEL 0`. | Se descartó el primer comando de exportación (formato `plantuml` genérico) y se usó `plantuml/c4plantuml`. Se descargó la CLI compilada, no el código fuente. | Giovani Angel Mendoza Contreras |
| 7 | 20/10/2026 | Resolver el conflicto de Git en `workspace.dsl` entre la versión del redactor y la de otro integrante. | Se conservó la versión del redactor: la validada, con «Sistema externo» en las descripciones. | Se descartó la versión de la generación inicial (filas 1.2 a 1.8) porque duplicaba elementos con otros nombres. | Giovani Angel Mendoza Contreras |
| 8 | 20/10/2026 | P5 · Revisión del modelo con el Anexo A y las reglas C4 del enunciado (Claude Code, solo lectura). Primero se revisó la versión de la generación inicial y después la del redactor (`4d937f1`), incluidos los `.puml` y los PNG. Resultado: 12 hallazgos, registrados en `revision-cruzada.md`. | 10 hallazgos (1 a 7 y 9 a 11), cada uno comprobado contra el DSL, los `.puml` o los PNG. Los principales: ADR-002 vacío; la relación del reto aparece en la vista base; el tráfico no pasa por el balanceador; IndexedDB sin justificar. | Se rechazaron 2 hallazgos. **Hallazgo 8** (paso para verificar el cupo antes de cobrar): controlar el cupo es una regla interna de la API y añadir ese paso sería más detalle del que pide el diagrama; el caso del último cupo se trata en el ADR-002. **Hallazgo 12** (`exclude` innecesario en el contexto): no cambia el diagrama generado. | Cristhian Matias Bravo Arredondo |
| 9 | 20/10/2026 | P6 · Propuesta de explicación del contexto para la gerente de una agencia de Chivay (200 a 250 palabras, basada en la vista `Contexto`), con revisión de jerga y de niveles mezclados (Claude Code). | La estructura en tres bloques (qué hace, quién lo usa, con quién se conecta), la comparación con el POS, la aclaración de que no se guardan datos de tarjetas y la frase de cierre. También se usó una guía de palabras clave pedida a la IA. | El vocero redactó la versión final con sus propias palabras. Cambió «plataforma» por la imagen de una vitrina del consorcio, le habló directamente a la gerente y reforzó que el guía no entra al sistema. Se aplicaron las reglas «sin jerga» y «solo nivel de contexto»: no menciona aplicación, servidor ni base de datos. Detalle en la tabla de cambios de `explicacion.md`. | Cristhian Matias Bravo Arredondo |

> En «Qué se rechazó o corrigió» se anota la regla de C4 usada. Sirve para la pregunta 3 de la socialización.

## Anexo A · Registro original de la generación inicial (copiado sin cambios)

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

## Anexo B · Registro original del redactor del DSL (copiado sin cambios)

Grupo N.º __ · Asistente usado: Claude (Anthropic) · Fecha: 20/10/2026

> Nota: estos registros salen de la conversación del redactor del DSL con el asistente.
> No se pegaron datos personales ni credenciales. Los prompts son resumidos, no literales.
> Si el grupo usó los prompts sugeridos P1 a P8 del documento, agreguen sus filas abajo.

| N.º | Fecha | Prompt (resumen) | Qué se aceptó | Qué se rechazó o corrigió | Responsable |
|-----|-------|------------------|---------------|---------------------------|-------------|
| 1 | 20/10/2026 | Estructura de trabajo del AG-08, si hacía falta trabajar en local y cómo organizar el repositorio. | Estructura de carpetas `docs/architecture/c4/ruta-colca/`, flujo por pasos y herramientas (Java, Structurizr CLI, PlantUML, Graphviz, Git). | Nada. Se contrastó con la Tabla 8 (entregables) del documento. | [nombre] |
| 2 | 20/10/2026 | Borrador completo de `workspace.dsl` (contexto, contenedores, dinámico, despliegue y reto sin conexión) para el rol de redactor del DSL. | Personas, 4 contenedores del ADR-001, 3 externos, relaciones con verbo y protocolo, vista dinámica con 6 pasos, despliegue con 2 VM y balanceador. | Supuestos de la IA que el grupo debe confirmar: guía como persona, boleto validado antes de cobrar, administrador usa el portal de agencias, IndexedDB como almacén local. **Pendiente: marcar aquí si el grupo los aceptó o cambió.** | [nombre] |
| 3 | 20/10/2026 | Revisión de las capturas del visor web (contexto y contenedores) contra la lista del Anexo A. | Observaciones sobre leyenda y sobre distinguir los sistemas externos. | La IA sugirió quitar el protocolo "WhatsApp" de la flecha al guía; **no se aplicó** y se mantuvo. | [nombre] |
| 4 | 20/10/2026 | Revisión de las 5 imágenes exportadas a PNG (C4-PlantUML). | Cambio en `workspace.dsl`: las descripciones de Pasarela de pagos, WhatsApp Business y AUTOCOLCA empiezan con "Sistema externo", porque el export C4-PlantUML pinta todo del mismo azul. Lo aplicó la IA al archivo y el redactor lo verificó al regenerar los PNG. | La IA sugirió declarar la relación web → balanceador en el despliegue; **no se aplicó**: se deja la deducción automática de Structurizr. | [nombre] |
| 5 | 20/10/2026 | Comandos para validar y exportar en Windows (CLI, `plantuml.jar`, Graphviz). Depuración de rutas, variable `RUTA`, archivo de imagen bloqueado y conflicto de Git. | Comandos de `validate`, `export` (c4plantuml y mermaid) y generación de PNG. El redactor los ejecutó y confirmó `ERRORLEVEL 0`. | Se descartó el primer comando de exportación (formato `plantuml` genérico) y se usó `plantuml/c4plantuml`. Se descargó la CLI compilada, no el código fuente. | [nombre] |
| 6 | 20/10/2026 | Resolver el conflicto de Git en `workspace.dsl` entre la versión del redactor y la de otro integrante. | Se conservó la versión del redactor (la validada, con "Sistema externo" en las descripciones). | Se descartó la otra versión del DSL porque duplicaba elementos con otros nombres. **Comunicar al integrante que su versión no se usó y por qué.** | [nombre] |

### Qué hizo cada parte (para la socialización)

- **La IA:** redactó el borrador del DSL, propuso los supuestos y las correcciones de descripciones, y guió los comandos.
- **El redactor del DSL:** ejecutó la CLI, validó (`ERRORLEVEL 0`), exportó a C4-PlantUML y Mermaid, generó los PNG, resolvió el conflicto de Git y subió el commit.
- **Pendiente del grupo:** confirmar los supuestos de la fila 2 y completar el número de grupo.

### Regla de C4 usada para rechazar una propuesta (pregunta 3 de la socialización)

La relación web → balanceador no se agregó porque el diagrama de despliegue solo debe usar instancias de contenedores del modelo y las relaciones ya existentes entre contenedores; agregarla a mano duplicaría una deducción automática de Structurizr.

> Nota del vocero: este motivo se revisó en la fila 8 (hallazgo 4) y se reemplazó por la corrección registrada en la fila 5 del registro principal.
