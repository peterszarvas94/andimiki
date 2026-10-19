FROM nginxinc/nginx-unprivileged:1.28-alpine
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf
COPY index.html favicon.svg background.png meghivo.png /usr/share/nginx/html/
EXPOSE 8080
