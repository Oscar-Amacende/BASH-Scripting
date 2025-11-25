#!/bin/bash
#Ejecucion diaria en cron#
#nombre del respaldo
nom="$1"
#Directorio a respaldar
dir="$2"
#Destino del respaldo
des="/var/respaldo/empresa"
tip="\e[1;32m"
d_form=$(date +%Y_%m-%d)
nreal="$nom-$d_form.tar.gz"

if [-z "$nom"] || [-z "$dir"]; then
  echo "uso : nombre_respaldo ruta_respaldo"
fi
#Verifica la existencia del destino
mkdir -p $dest

tar -czf "$nreal" -C $(dirname "$dir") $(basename "$dir") 2>/dev/null

if [ $? -eq 0 ] ; then
  echo -e "${tip} respaldado : $nreal"
else
  echo "error"
  exit 1
fi

#Limpieza +30 días
find "$des" -name "*.tar.gz" -type f -mtime +30 -delete
