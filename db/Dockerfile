FROM mysql:8

# ruta absoluta desde la raíz del proyecto
COPY db/script_db/innova_tech_DDL.sql /docker-entrypoint-initdb.d/01_schema.sql
COPY db/script_db/innova_tech_DML.sql /docker-entrypoint-initdb.d/02_seed.sql

VOLUME /var/lib/mysql