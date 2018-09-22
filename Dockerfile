FROM node:10-alpine

LABEL maintainer="Luca Perret <perret.luca@gmail.com>" \
      org.label-schema.vendor="Strapi" \
      org.label-schema.name="Strapi Docker image" \
      org.label-schema.description="Strapi containerized" \
      org.label-schema.url="https://strapi.io" \
      org.label-schema.vcs-url="https://github.com/strapi/strapi-docker" \
      org.label-schema.version=latest \
      org.label-schema.schema-version="1.0"

WORKDIR /usr/src/api
ARG STRAPI_VERSION

RUN npm install -g strapi@$STRAPI_VERSION

ENV STRAPI_BUILD_VERSION=$STRAPI_VERSION
ENV APP_NAME=${APP_NAME:-strapi-app}
ARG DATABASE_CLIENT=${DATABASE_CLIENT:-mongo}
ENV DATABASE_HOST=${DATABASE_HOST:-172.17.0.1}
ENV DATABASE_PORT=${DATABASE_PORT:-27017}
ENV DATABASE_NAME=${DATABASE_NAME:-strapi}

RUN strapi new ${APP_NAME} --dbclient=$DATABASE_CLIENT --dbhost=$DATABASE_HOST --dbport=$DATABASE_PORT --dbname=$DATABASE_NAME --dbusername=$DATABASE_USERNAME --dbpassword=$DATABASE_PASSWORD --dbssl=$DATABASE_SSL --dbauth=$DATABASE_AUTHENTICATION_DATABASE
RUN npm install --prefix ./$APP_NAME

COPY healthcheck.js ./
HEALTHCHECK --interval=15s --timeout=5s --start-period=30s \
      CMD node /usr/src/api/healthcheck.js

COPY strapi.sh ./
RUN chmod +x ./strapi.sh

CMD ["./strapi.sh"]

EXPOSE 1337
