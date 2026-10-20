#!/usr/bin/env bash
# Valida el modelo y genera C4-PlantUML, Mermaid y PNG (Paso 9).
# Requiere: structurizr.sh (Structurizr CLI) y plantuml.jar en la raíz o en el PATH.
set -euo pipefail

WS=docs/architecture/c4/ruta-colca/workspace.dsl
OUT=docs/architecture/c4/ruta-colca/export
STRUCTURIZR=${STRUCTURIZR:-./structurizr.sh}
PLANTUML_JAR=${PLANTUML_JAR:-plantuml.jar}

"$STRUCTURIZR" validate -w "$WS"
"$STRUCTURIZR" export -w "$WS" -f plantuml/c4plantuml -o "$OUT"
"$STRUCTURIZR" export -w "$WS" -f mermaid -o "$OUT"
java -jar "$PLANTUML_JAR" -tpng -o ../img "$OUT"/*.puml

echo "Listo: diagramas en $OUT y PNG en docs/architecture/c4/ruta-colca/img"
