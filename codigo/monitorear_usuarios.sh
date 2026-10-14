#!/bin/bash
#
# monitorear_usuarios.sh
# TP3 - Automatización y Scripting - Legajo 9110
# Token de Autenticidad: 91109895
#
# Registra en un log la fecha/hora y los usuarios con sesión activa.
# Pensado para ejecutarse vía cron cada 10 minutos, lunes a viernes.

LEGAJO="9110"
TOKEN="91109895"
LOG="$(dirname "$0")/../logs/usuarios_activos_9110.log"

# Si el archivo de log no existe todavía, lo creamos con encabezado
if [[ ! -f "$LOG" ]]; then
    {
        echo "############################################"
        echo "# Log de usuarios activos - Legajo $LEGAJO"
        echo "# Token de Autenticidad: $TOKEN"
        echo "############################################"
    } > "$LOG"
fi

FECHA=$(date '+%Y-%m-%d %H:%M:%S')
CANTIDAD=$(who | wc -l)

if [[ -z "$USUARIOS" ]]; then
    USUARIOS="(sin sesiones activas)"
fi

echo "[$FECHA] Usuarios activos: $CANTIDAD" >> "$LOG"
