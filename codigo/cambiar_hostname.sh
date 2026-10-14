#!/bin/bash
#
# cambiar_hostname.sh
# TP3 - Automatización y Scripting - Legajo 9110
#
# Cambia el nombre de host del sistema. Recibe el nombre nuevo como
# argumento y modifica /etc/hostname y /etc/hosts.
# El nombre debe seguir la nomenclatura: curzas-alumno-9110
#
# Uso: sudo ./cambiar_hostname.sh curzas-alumno-9110

LEGAJO="9110"
NOMBRE_ESPERADO="curzas-alumno-$LEGAJO"

# Archivos a modificar (se pueden redefinir por variable de entorno
# SOLO para hacer pruebas sobre copias sin tocar el sistema real)
ARCHIVO_HOSTNAME="${ARCHIVO_HOSTNAME:-/etc/hostname}"
ARCHIVO_HOSTS="${ARCHIVO_HOSTS:-/etc/hosts}"

NUEVO="$1"

# 1) Seguridad: se requieren privilegios de administrador
if [[ $EUID -ne 0 ]]; then
    echo "Error: este script requiere privilegios de administrador. Ejecutelo con sudo." >&2
    exit 1
fi

# 2) Validación de argumento
if [[ -z "$NUEVO" ]]; then
    echo "Error: debe indicar el nombre nuevo como argumento." >&2
    echo "Uso: sudo $0 $NOMBRE_ESPERADO" >&2
    exit 1
fi

# 3) Validación de nomenclatura: curzas-alumno-[LEGAJO]
if [[ "$NUEVO" != "$NOMBRE_ESPERADO" ]]; then
    echo "Error: el nombre debe seguir la nomenclatura $NOMBRE_ESPERADO" >&2
    exit 1
fi

# 4) Leer el hostname actual (referencia vieja a reemplazar en /etc/hosts)
VIEJO=$(cat "$ARCHIVO_HOSTNAME")

if [[ -z "$VIEJO" ]]; then
    echo "Error: no se pudo leer el hostname actual de $ARCHIVO_HOSTNAME." >&2
    exit 1
fi

if [[ "$VIEJO" == "$NUEVO" ]]; then
    echo "El hostname ya es $NUEVO. No hay nada que cambiar."
    exit 0
fi

# 5) Backups por seguridad antes de modificar
cp "$ARCHIVO_HOSTNAME" "$ARCHIVO_HOSTNAME.bak"
cp "$ARCHIVO_HOSTS" "$ARCHIVO_HOSTS.bak"

# 6) Modificar /etc/hostname y reemplazar la referencia vieja en /etc/hosts
echo "$NUEVO" > "$ARCHIVO_HOSTNAME"
sed -i "s/\b$VIEJO\b/$NUEVO/g" "$ARCHIVO_HOSTS"

echo "Hostname cambiado: $VIEJO -> $NUEVO"
echo "Backups: $ARCHIVO_HOSTNAME.bak y $ARCHIVO_HOSTS.bak"
echo "Reinicie o ejecute 'hostnamectl set-hostname $NUEVO' para aplicarlo ya."
