# Reverse Proxy with Nginx

Since the whole project is deployed using Docker containers with different ports I decide to implement a [reverse proxy using Nginx](https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/). Using that I only allow the following ports to be accessed from outside:

- `443`: I already configured self-signed certificates with [Certbot](https://certbot.eff.org/pages/about) to serve the project through **https**.
- `80`: Just for those who want to enter using **http**, but they will be redirected to the secure port.

## Config file

You can find the whole configuration for this project in `config/default.conf`.