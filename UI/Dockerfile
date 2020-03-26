FROM node:8 as builder
COPY . /app
WORKDIR /app
RUN npm install

FROM docker.io/nginx:latest
COPY --from=builder docker/default.conf /etc/nginx/conf.d/default.conf.templ
COPY --from=builder docker/conf-builder.sh /usr/bin/conf-builder.sh
COPY --from=builder dist /usr/share/nginx/html
RUN chown -R nginx:nginx /usr/share/nginx/html/
EXPOSE 80 443
CMD conf-builder.sh &&\
  nginx -g "daemon off;"
