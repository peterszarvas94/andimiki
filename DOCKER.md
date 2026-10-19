# Docker deployment

Build from the repository root:

```sh
docker build -t andimiki .
docker run --rm -p 127.0.0.1:8080:8080 andimiki
```

The image serves the site on port 8080 as an unprivileged user. Put your
HTTPS reverse proxy in front of this port. In Coolify choose the Dockerfile
build pack, repository-root build context, /Dockerfile, and exposed port 8080.
The existing SSH deployment remains available.

Deployments are managed by central Coolify on Shared. Pushes to the configured
production branch deploy automatically through the Forgejo bridge. Host Caddy
provides HTTPS; application listeners are bound to loopback.
