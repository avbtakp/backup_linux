#!/bin/bash
date=$(date +"%d-%b-%Y")

#Excluir bases de datos del sistema
DATABASES_TO_EXCLUDE="mysql"
EXCLUSION_LIST="'information_schema','performance_schema'"
for DB in `echo "${DATABASES_TO_EXCLUDE}"`
do
    EXCLUSION_LIST="${EXCLUSION_LIST},'${DB}'"
done
SQLSTMT="SELECT schema_name FROM information_schema.schemata"
SQLSTMT="${SQLSTMT} WHERE schema_name NOT IN (${EXCLUSION_LIST})"

for DB in `mysql -Bse "${SQLSTMT}" -u USUARIO -pPASS`;
do mysqldump -v -f --opt --events --routines --triggers -u USUARIO -pPASS -x $DB > "$DB.sql";
done

#Crea carpeta
Ubique="/home/backup"
ubicacion=$(mkdir -m 755 /home/backup/$date)

#Mueve todos los archivos
mv *.sql /home/backup/$date
rm /home/backup/$date/sys.sql

#Elimina archivos de 3 días
find /home/backup* -mtime 1 -type d -exec rm -r -f {} \;

