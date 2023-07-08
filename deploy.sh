set -e
source .env
source BuildService.sh

docker compose -f docker-compose.yml --env-file .env up -d mongo-express

BuildService create-api \
    ms-hari-betest-create-api \
    $CONTAINER_HTTP_PORT \
    $DATABASE_CONNECTION_URL

BuildService read-api \
    ms-hari-betest-read-api \
    $CONTAINER_HTTP_PORT \
    $DATABASE_CONNECTION_URL

BuildService update-api \
    ms-hari-betest-update-api \
    $CONTAINER_HTTP_PORT \
    $DATABASE_CONNECTION_URL

BuildService delete-api \
    ms-hari-betest-delete-api \
    $CONTAINER_HTTP_PORT \
    $DATABASE_CONNECTION_URL