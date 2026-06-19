FROM mysql:8

# error corregido le quitamos el db/
COPY script_db/innova_tech_DDL.sql /docker-entrypoint-initdb.d/01_schema.sql
COPY script_db/innova_tech_DML.sql /docker-entrypoint-initdb.d/02_seed.sql

VOLUME /var/lib/mysql