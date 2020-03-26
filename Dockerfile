FROM node:8 as node
COPY . /app
WORKDIR /app/UI
RUN npm install

FROM maven:3-jdk-8 as builder
COPY --from=node /app /app
WORKDIR /app
RUN mvn clean install

FROM docker.io/nginx:latest
COPY --from=builder /app/UI/docker/default.conf /etc/nginx/conf.d/default.conf.templ
COPY --from=builder /app/UI/docker/conf-builder.sh /usr/bin/conf-builder.sh
COPY --from=builder /app/UI/dist /usr/share/nginx/html
RUN chown -R nginx:nginx /usr/share/nginx/html/
EXPOSE 80 443
CMD conf-builder.sh &&\
  nginx -g "daemon off;"
