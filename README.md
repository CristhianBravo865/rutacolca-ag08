# RutaColca · Modelo C4 (Caso práctico grupal AG-08)

Construcción de Software (1703243) · 2026-B · EPIS-UNSA

## Integrantes y roles

| Integrante | Rol Parte A | Rol Parte B |
|---|---|---|
| | Modelador | |
| | Redactor del DSL | |
| | Revisor | |
| | Vocero | |

## Entregables

| Código | Archivo | Parte |
|---|---|---|
| E1 | [`inventario.md`](docs/architecture/c4/ruta-colca/inventario.md) | A |
| E2 | [`workspace.dsl`](docs/architecture/c4/ruta-colca/workspace.dsl) (contexto, contenedores, dinámico) | A |
| E3 | [`revision-cruzada.md`](docs/architecture/c4/ruta-colca/revision-cruzada.md) y [`explicacion.md`](docs/architecture/c4/ruta-colca/explicacion.md) | A |
| E4 | `workspace.dsl` con despliegue y vista `ContenedoresReto` | B |
| E5 | [`ADR-002-trabajo-sin-conexion.md`](docs/architecture/adr/ADR-002-trabajo-sin-conexion.md) | B |
| E6 | [`export/`](docs/architecture/c4/ruta-colca/export/) (C4-PlantUML, Mermaid y PNG en `img/`) | B |
| E7 | [`bitacora-ia.md`](docs/architecture/c4/ruta-colca/bitacora-ia.md) | A y B |

## Validar y exportar

Desde la raíz del repositorio, con la Structurizr CLI y `plantuml.jar` disponibles:

```bash
./scripts/validar-exportar.sh
```

El modelo debe validar sin errores antes de subir el commit final.
