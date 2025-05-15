#!/bin/bash
mkdir -p /etc/nginx/ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/nginx/ssl/nginx.key \
  -out /etc/nginx/ssl/nginx.crt \
  -subj "/C=XX/ST=State/L=City/O=Organization/CN=localhost"
chmod 600 /etc/nginx/ssl/nginx.key /etc/nginx/ssl/nginx.crt