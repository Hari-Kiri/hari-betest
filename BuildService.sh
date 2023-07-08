BuildService() {
    image_name=${2,,}
    echo "Building \"$1\" container. Please wait..."
    rm -rf $2
    git clone https://github.com/Hari-Kiri/$2.git
    IMAGE="$(docker images -q $image_name:latest)"
    if [ "$IMAGE" = "" ]; then
        DOCKER_BUILDKIT=1 docker build \
            --build-arg PROJECT_NAME=$2 \
            --build-arg CONTAINER_HTTP_PORT=$3 \
            --build-arg DATABASE_CONNECTION_URL=$4 \
            --file Dockerfile \
            -t $image_name:latest .
    fi
    docker compose -f docker-compose.yml --env-file .env up -d $1
    rm -rf $2
    echo
}