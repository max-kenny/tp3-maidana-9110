#!/bin/bash
#
# descarga_programada.sh
# TP3 - Automatización y Scripting - Legajo 9110
#
# Recibe una URL como parámetro y descarga el archivo a la carpeta
# local descargas/. Pensado para dispararse una única vez vía `at`.

DIR_DESCARGAS="$(dirname "$0")/../descargas"
URL="$1"

# Validación de entrada: debe recibir exactamente una URL
if [[ -z "$URL" ]]; then
    echo "Error: debe indicar una URL como parámetro." >&2
    echo "Uso: $0 <url_del_archivo>" >&2
    exit 1
fi

mkdir -p "$DIR_DESCARGAS"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Iniciando descarga de: $URL"

if command -v wget >/dev/null 2>&1; then
    wget -q -P "$DIR_DESCARGAS" "$URL"
    RESULTADO=$?
elif command -v curl >/dev/null 2>&1; then
    ARCHIVO="$DIR_DESCARGAS/$(basename "$URL")"
    curl -s -o "$ARCHIVO" "$URL"
    RESULTADO=$?
else
    echo "Error: no se encontró wget ni curl instalado." >&2
    exit 1
fi

if [[ $RESULTADO -eq 0 ]]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Descarga completada en $DIR_DESCARGAS/$(basename "$URL")"
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Error: la descarga falló (código $RESULTADO)." >&2
    exit "$RESULTADO"
fi
