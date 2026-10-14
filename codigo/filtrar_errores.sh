#!/bin/bash
#
# filtrar_errores.sh
# TP3 - Automatización y Scripting - Legajo 9110
#
# Lee un syslog y genera un reporte de ancho fijo solo con las líneas
# que contengan "error", "fail" o "critical" (sin distinguir mayúsculas).
#
# Uso: ./filtrar_errores.sh [archivo_syslog]
#      (por defecto usa recursos/syslog_prueba.txt)

LEGAJO="9110"
BASE="$(dirname "$0")/.."
ENTRADA="${1:-$BASE/recursos/syslog_prueba.txt}"
SALIDA="$BASE/logs/reporte_errores_$LEGAJO.txt"

if [[ ! -r "$ENTRADA" ]]; then
    echo "Error: no se puede leer el archivo $ENTRADA" >&2
    exit 1
fi

mkdir -p "$BASE/logs"

# Formato esperado de cada línea:
#   $1=Mes  $2=Día  $3=Hora  $4=Host  $5=Proceso[PID]:  $6...=Mensaje
awk '
BEGIN {
    # Encabezado del reporte (ancho fijo)
    printf "%-8s %-9s %-20s %-50s\n", "FECHA", "HORA", "PROCESO", "MENSAJE"
    printf "%-8s %-9s %-20s %-50s\n", "--------", "---------", "--------------------", "--------------------------------------------------"
}
# Filtro: la línea completa en minúsculas contiene error, fail o critical
tolower($0) ~ /error|fail|critical/ {
    fecha = $1 " " $2

    # Proceso: se quita el PID entre corchetes y los dos puntos finales
    proceso = $5
    sub(/\[[0-9]+\]:?$/, "", proceso)
    sub(/:$/, "", proceso)

    # Mensaje: todo lo que sigue a la columna 5, recortado a 50 caracteres
    msg = $6
    for (i = 7; i <= NF; i++) msg = msg " " $i
    msg = substr(msg, 1, 50)

    printf "%-8s %-9s %-20s %-50s\n", fecha, $3, proceso, msg
}
' "$ENTRADA" > "$SALIDA"

echo "Reporte generado en: $SALIDA"
