docker stop proxy-betest mongo mongo-express create-api read-api update-api delete-api
docker rm proxy-betest mongo mongo-express create-api read-api update-api delete-api
docker rmi ms-hari-betest-create-api:latest ms-hari-betest-read-api:latest ms-hari-betest-update-api:latest ms-hari-betest-delete-api:latest
docker builder prune -af