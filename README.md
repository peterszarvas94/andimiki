# andimiki static site

Simple static page for `andiesmiki.hu`.

## Files

- `index.html`
- `img1.jpeg`
- `img2.jpeg`
- `favicon.svg`
- `favicon-test.svg`
- `deploy.sh`
- `nginx/andiesmiki.hu.conf`

## Deploy content to current server

From this directory:

```bash
./deploy.sh
```

Dry run:

```bash
./deploy.sh --dry-run
```

Override defaults:

```bash
REMOTE=peti@shared REMOTE_DIR=/var/www/andiesmiki.hu ./deploy.sh
```

## Set up on a new server

1. Install packages:

```bash
sudo apt update
sudo apt install -y nginx certbot
```

2. Create web roots:

```bash
sudo mkdir -p /var/www/andiesmiki.hu
sudo mkdir -p /var/www/certbot
sudo chown -R "$USER":"$USER" /var/www/andiesmiki.hu
sudo chown -R www-data:www-data /var/www/certbot
```

3. Point DNS:

- `A andiesmiki.hu -> <server-ipv4>`
- `CNAME www.andiesmiki.hu -> andiesmiki.hu`

4. Upload site files:

```bash
./deploy.sh
```

5. Install nginx config:

```bash
sudo cp nginx/andiesmiki.hu.conf /etc/nginx/sites-available/andiesmiki.hu.conf
sudo ln -sfn /etc/nginx/sites-available/andiesmiki.hu.conf /etc/nginx/sites-enabled/andiesmiki.hu.conf
sudo nginx -t
sudo systemctl reload nginx
```

6. Issue/expand TLS certificate:

```bash
sudo certbot certonly \
  --webroot -w /var/www/certbot \
  -d andiesmiki.hu -d www.andiesmiki.hu \
  --cert-name andiesmiki.hu \
  --expand \
  --non-interactive --agree-tos \
  -m contact@peterszarvas.hu
```

7. Reload nginx after certificate update:

```bash
sudo nginx -t
sudo systemctl reload nginx
```

8. Verify behavior:

```bash
curl -I http://andiesmiki.hu
curl -I http://www.andiesmiki.hu
curl -I https://www.andiesmiki.hu
curl -I https://andiesmiki.hu
```

Expected:

- everything redirects to `https://andiesmiki.hu`
- `https://andiesmiki.hu` serves `index.html`
