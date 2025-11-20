#!/bin/bash
set -e

# Esperar a que la base de datos esté lista (si se usa PostgreSQL)
if [ "$DATABASE" = "postgres" ]; then
    echo "Esperando a PostgreSQL..."
    while ! nc -z ${DB_HOST:-db} ${DB_PORT:-5432}; do
        sleep 0.1
    done
    echo "PostgreSQL está listo"
fi

# Ejecutar migraciones
echo "Ejecutando migraciones..."
python manage.py migrate --noinput || true

# Recopilar archivos estáticos
echo "Recopilando archivos estáticos..."
python manage.py collectstatic --noinput || true

# Ejecutar el comando proporcionado
exec "$@"

