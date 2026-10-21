# E3 · Revisión cruzada (Paso 5)

- **Modelo revisado (otro grupo):** se identifica en clase
- **Nuestro modelo fue revisado por:** se identifica en clase (nuestro grupo no tiene número asignado)
- **Revisor del grupo:** Fernando Gerson Luque Guevara
- **Revisión interna previa:** Cristhian Matias Bravo Arredondo (vocero), con apoyo de IA (P5) · 20/10/2026

Lista aplicada: Anexo A (resumen de c4model.com/diagrams/checklist).

> **Revisión cruzada con otro grupo:** todavía no se ha hecho. Se hace en clase. Sus resultados irán en las dos últimas tablas.

## 1. Revisión interna de nuestro modelo

- **Versión revisada:** `workspace.dsl` del commit `4d937f1`, versión del redactor Giovani Angel Mendoza Contreras, junto con `inventario.md`, `ADR-002`, los `.puml` de `export/` y los PNG de `img/`.
- **Cómo se revisó:** se leyeron el DSL y los archivos exportados, y se miraron los PNG de Contexto y Despliegue.
- **Validación:** la ejecutó el redactor con `structurizr.sh validate`, y terminó con `ERRORLEVEL 0` (fila 6 de `bitacora-ia.md`).
- **Resultado:** de 12 hallazgos, el grupo **aceptó 10 y rechazó 2**. Cada corrección aceptada tiene un responsable asignado.

| N.º | Hallazgo | Elemento o relación | Gravedad | Corrección | ¿Lo aceptamos? | Motivo |
|---|---|---|---|---|---|---|
| 1 | El ADR-002 sigue siendo la plantilla, aunque el DSL ya modela el reto. El propio DSL dice «SUPUESTO del grupo. Ajústenlo con su ADR-002». | `ADR-002-trabajo-sin-conexion.md` | Alta | Redactar el ADR-002: contenedor nuevo, relaciones del portal, nodo de despliegue y regla para el último cupo (la API rechaza la reserva sincronizada si el cupo ya se agotó). | **Sí** | Es el entregable E5 y justifica el reto. Responsable: el integrante al que le toque el ADR-002 al rotar los roles en la Parte B (todavía sin asignar). |
| 2 | En los PNG exportados, los sistemas externos salen del mismo azul que RutaColca, porque C4-PlantUML no toma el estilo «Externo». Comprobado en `structurizr-Contexto.png`. | Pasarela, WhatsApp, AUTOCOLCA en los PNG | Media | Mantener «Sistema externo» al inicio de cada descripción (ya está en `4d937f1`) y dejar escrita la limitación en el `README.md` (ya está). | **Sí** | La regla pide que los externos se distingan. En el visor de Structurizr salen en gris; en el PNG se distinguen por el texto. |
| 3 | El diagrama base `Contenedores` (Parte A) muestra la flecha portal → API «Sincroniza reservas pendientes con», que es parte del reto. Comprobado en `structurizr-Contenedores.puml`. | `ruta.portal -> ruta.api "Sincroniza…"` | Media | Ponerle la etiqueta «Reto» a esa relación y agregar `exclude "relationship.tag==Reto"` en la vista `Contenedores`. | **Sí** | La vista de la Parte A no debe mostrar cambios de la Parte B. Si no, no se puede comparar con `ContenedoresReto`. Responsable: Giovani (DSL). |
| 4 | En el despliegue, la web y el portal llegan directo a la API, aunque el balanceador «termina TLS y reparte el tráfico». El motivo que se dio para no agregar web → balanceador no es correcto: Structurizr no deduce relaciones hacia un `infrastructureNode`, y la regla de despliegue prohíbe crear **contenedores** nuevos, no relacionar instancias con nodos de infraestructura. | `production.cloud.lb`, `webInst`, `portalInst` | Media | Agregar `webInst -> lb` y `portalInst -> lb` con la etiqueta «Envía peticiones a» y el protocolo «HTTPS». | **Sí** | El diagrama de despliegue debe mostrar el camino real del tráfico. Responsable: Giovani (DSL). |
| 5 | IndexedDB no figura en el ADR-001 y no hay ningún ADR que lo justifique. | `ruta.offline` | Media | Justificarlo en el ADR-002: es el almacenamiento del navegador que usa la misma PWA de React. | **Sí** | Regla: solo tecnologías del ADR-001 o de una decisión registrada. Se resuelve con el hallazgo 1. |
| 6 | El despliegue usa supuestos de infraestructura que no están en el ADR-001: Ubuntu 24.04, Android / iOS / iPadOS y Chrome / Safari. Además, la tablet dice «Android / iPadOS» y su navegador dice solo «Chrome». | Nodos de `Produccion` | Baja | Anotarlos como supuestos en el ADR-002 y cambiar el navegador de la tablet a «Chrome / Safari». | **Sí** | Regla: no agregar tecnologías sin respaldo. Responsable: Giovani (DSL) y quien redacte el ADR-002. |
| 7 | La descripción de AUTOCOLCA dice «API HTTPS». Es jerga en el diagrama que ve un público no técnico. | `autocolca` | Baja | Cambiarla por «Sistema externo que emite y valida el boleto turístico del Colca (supuesto didáctico)». | **Sí** | El nivel de contexto no debe tener detalles técnicos. Responsable: Giovani (DSL). |
| 8 | La vista dinámica no tiene un paso que verifique el cupo antes de cobrar. | Vista `Dinamico` | Baja | — | **No** | La vista ya muestra lo que pide el caso: validar el boleto antes de cobrar y guardar la reserva confirmada. Controlar el cupo es una regla interna de la API y añadir ese paso sería más detalle del que pide el diagrama. El caso del último cupo se trata en el ADR-002 (hallazgo 1). |
| 9 | El caso no dice que el administrador use el portal de agencias. | `admin -> ruta.portal` | Baja | Anotar en `inventario.md` que el administrador usa el portal de agencias. | **Sí** | El grupo confirmó el supuesto (fila 3 de `bitacora-ia.md`); hay que dejarlo escrito. Responsable: Fernando (inventario). |
| 10 | El inventario pone el almacén local (Parte B) en la tabla de la Parte A sin marcarlo, y la fila de AUTOCOLCA usa «API HTTPS». | `inventario.md` | Baja | Marcar esa fila como «Parte B / reto» y quitar la jerga. | **Sí** | Hay que separar la Parte A de la Parte B. Responsable: Fernando (inventario). |
| 11 | El nombre del workspace todavía tiene el texto de la plantilla «Grupo N.º __». | `workspace` | Baja | Quitar el marcador «Grupo N.º __», porque el grupo no tiene número asignado, y dejar solo el nombre del caso. | **Sí** | Un marcador de plantilla no debe quedar en el entregable. Responsable: Giovani (DSL). |
| 12 | `exclude ruta.offline` en la vista `Contexto` no hace nada, porque en el contexto no se muestran contenedores. | Vista `Contexto` | Baja | — | **No** | No cambia el diagrama generado y la validación pasa. Tocar el DSL solo por eso no aporta nada. |

### Hallazgos de la revisión anterior (sobre la generación inicial, commit `cb582cd`)

Así quedaron en la versión `4d937f1`, según lo comprobado leyendo el DSL y los `.puml`:

| Hallazgo anterior | Estado en `4d937f1` |
|---|---|
| RutaColca → guía directo en el contexto | Resuelto: solo existe WhatsApp → guía, y ahora es coherente con la decisión de `inventario.md`. |
| Ida y vuelta entre el portal y el almacén local | Resuelto: solo queda portal → almacén. |
| El balanceador no tenía relaciones | Resuelto en parte: ahora tiene balanceador → API. Lo que falta está en el hallazgo 4. |
| Protocolo inconsistente hacia la pasarela | Resuelto: las tres llamadas a sistemas externos usan «HTTPS». |
| Las vistas no tenían `title` | Resuelto: las 5 vistas tienen `title`, y la leyenda aparece en los PNG revisados. |
| La base de datos no tenía forma de cilindro | Resuelto: la etiqueta «Almacen» le da forma de cilindro. |
| «API» en el inventario y «API de negocio» en el DSL | Resuelto: los dos dicen «API». |
| El cupo se actualizaba recién después del cobro | Rechazado: ver hallazgo 8. |
| La vista base ya mostraba la sincronización | Sigue igual: ver hallazgo 3. |
| ADR-002 vacío / IndexedDB sin justificar | Sigue igual: ver hallazgos 1 y 5. |

### Reglas que sí se cumplen

- RutaColca es una sola caja en el contexto.
- Docker solo aparece como tecnología de los nodos, no como contenedor.
- Los contenedores base usan las tecnologías del ADR-001.
- Las relaciones van en un solo sentido y tienen verbo, preposición y protocolo.
- Las 5 vistas tienen título y leyenda.
- El despliegue usa `containerInstance` de contenedores que ya existen, con 2 instancias de la API.
- No aparecen Kafka, Redis, Kubernetes ni apps móviles nativas.
- No hay sistemas inventados.

## 2. Hallazgos recibidos sobre nuestro modelo (revisión cruzada en clase)

| N.º | Hallazgo | ¿Lo aceptamos? | Motivo |
|---|---|---|---|
| 1 | | | |
| 2 | | | |
| 3 | | | |

## 3. Hallazgos que hicimos al otro grupo (revisión cruzada en clase)

| N.º | Hallazgo | Elemento o relación | Gravedad (alta, media, baja) | Corrección sugerida |
|---|---|---|---|---|
| 1 | | | | |
| 2 | | | | |
| 3 | | | | |

> Los hallazgos de la sección 1 vinieron de la IA (prompt P5). Se comprobaron contra el modelo antes de decidir y están registrados en `bitacora-ia.md` (fila 8).
