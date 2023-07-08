# Use Alpine linux images
FROM alpine:latest

ARG DATABASE_CONNECTION_URL
ARG CONTAINER_HTTP_PORT
ARG PROJECT_NAME

# Add repo local folder to container
ADD ${PROJECT_NAME} /root/${PROJECT_NAME}

RUN mkdir /var/log/supervisor
# Install dependencies
RUN apk add --update --no-cache supervisor git npm \
    && cd /root/${PROJECT_NAME} \
    && npm install \
    # Create supervisord.conf
    && echo -e "[unix_http_server]\n" > /etc/supervisord.conf \
    && echo -e "file=/dev/shm/supervisor.sock\n" >> /etc/supervisord.conf \
    && echo -e "chmod=0700\n" >> /etc/supervisord.conf \
    && echo -e "username=dummy\n" >> /etc/supervisord.conf \
    && echo -e "password=dummy\n\n" >> /etc/supervisord.conf \
    && echo -e "[supervisord]\n" >> /etc/supervisord.conf \
    && echo -e "nodaemon=true\n" >> /etc/supervisord.conf \
    && echo -e "user=root\n" >> /etc/supervisord.conf \
    && echo -e "logfile=/var/log/supervisor/supervisord.log\n" >> /etc/supervisord.conf \
    && echo -e "childlogdir=/var/log/supervisor\n\n" >> /etc/supervisord.conf \
    && echo -e "[rpcinterface:supervisor]\n" >> /etc/supervisord.conf \
    && echo -e "supervisor.rpcinterface_factory=supervisor.rpcinterface:make_main_rpcinterface\n\n" >> /etc/supervisord.conf \
    && echo -e "[supervisorctl]\n" >> /etc/supervisord.conf \
    && echo -e "serverurl=unix:///dev/shm/supervisor.sock\n" >> /etc/supervisord.conf \
    && echo -e "username=dummy\n" >> /etc/supervisord.conf \
    && echo -e "password=dummy\n\n" >> /etc/supervisord.conf \
    && echo -e "[program:$PROJECT_NAME]\n" >> /etc/supervisord.conf \
    && echo -e "directory=/root/$PROJECT_NAME\n" >> /etc/supervisord.conf \
    && echo -e "autostart=true\n" >> /etc/supervisord.conf \
    && echo -e "autorestart=true\n" >> /etc/supervisord.conf \
    && echo -e "stdout_logfile=/dev/stdout\n" >> /etc/supervisord.conf \
    && echo -e "stdout_logfile_maxbytes=0\n" >> /etc/supervisord.conf \
    && echo -e "stderr_logfile=/dev/stderr\n" >> /etc/supervisord.conf \
    && echo -e "stderr_logfile_maxbytes=0\n" >> /etc/supervisord.conf \
    && echo -e "command=/bin/ash -c \"node app.js\"" >> /etc/supervisord.conf
RUN rm -rf /tmp/* /var/cache/apk/*

ENV TZ="Asia/Jakarta"
ENV HTTP_PORT=${CONTAINER_HTTP_PORT}
ENV DATABASE_CONNECTION_URL=${DATABASE_CONNECTION_URL}

# Expose the required port
EXPOSE ${CONTAINER_HTTP_PORT}

# Launch service in foreground
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
