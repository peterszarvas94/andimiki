FROM caddy:2.11-alpine
COPY docker/Caddyfile /etc/caddy/Caddyfile
COPY index.html favicon.svg background.png meghivo.png /srv/
USER 10001:10001
EXPOSE 8080
