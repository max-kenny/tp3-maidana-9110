#!/bin/bash
#
# diagnostico_red.sh
# TP3 - Automatización y Scripting - Legajo 9110
#
# Hace ping a la puerta de enlace (gateway) local y guarda la
# respuesta en un log acumulativo. Pensado para ser disparado por
# el servicio systemd monitoreo_9110.service.

LOG="$(dirname "$0")/../logs/ping_report_9110.log"
FECHA=$(date '+%Y-%m-%d %H:%M:%S')

# Detectamos automáticamente la IP del gateway por defecto
GATEWAY=$(ip route | awk '/^default/ {print $3; exit}')

if [[ -z "$GATEWAY" ]]; then
    echo "[$FECHA] Error: no se pudo determinar la IP del gateway." >> "$LOG"
    exit 1
fi

echo "[$FECHA] Haciendo ping a gateway $GATEWAY" >> "$LOG"

# -c 4: cuatro paquetes. -W 2: timeout de 2s por paquete.
if ping -c 4 -W 2 "$GATEWAY" >> "$LOG" 2>&1; then
    echo "[$FECHA] Resultado: gateway $GATEWAY responde OK" >> "$LOG"
else
    echo "[$FECHA] Resultado: gateway $GATEWAY NO responde" >> "$LOG"
fi

echo "----------------------------------------" >> "$LOG"
