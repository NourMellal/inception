FROM debian:bookworm

RUN apt update && apt install nginx -y && apt install openssl -y

COPY conf/nginx.conf /etc/nginx/nginx.conf

COPY tools/generate_ssl.sh /tmp/


RUN chmod +x /tmp/generate_ssl.sh && /tmp/generate_ssl.sh

EXPOSE 443

ENTRYPOINT [ "nginx", "-g", "daemon off;" ]