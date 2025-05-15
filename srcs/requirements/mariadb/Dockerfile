FROM debian:bookworm

RUN apt update && apt install -y mariadb-server


RUN mkdir -p /var/lib/mysql /var/run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql /var/run/mysqld && \
    chmod 777 /var/run/mysqld

COPY ./tools/init.sh /docker-entrypoint-initdb.d/

ARG MYSQL_ROOT_PASSWORD
ENV MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
ARG MYSQL_DATABASE
ENV MYSQL_DATABASE=${MYSQL_DATABASE}
ARG MYSQL_USER
ENV MYSQL_USER=${MYSQL_USER}
ARG MYSQL_PASSWORD
ENV MYSQL_PASSWORD=${MYSQL_PASSWORD}


RUN chmod +x /docker-entrypoint-initdb.d/init.sh


EXPOSE 3306

CMD [ "mariadb"]