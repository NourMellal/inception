FROM debian:bookworm

RUN apt update && apt install -y mariadb-server

# Create necessary directories with correct permissions
RUN mkdir -p /var/lib/mysql /var/run/mysqld /var/log/mysql && \
    chown -R mysql:mysql /var/lib/mysql /var/run/mysqld /var/log/mysql && \
    chmod 777 /var/run/mysqld && \
    chmod 755 /var/log/mysql

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/


ARG MYSQL_ROOT_PASSWORD
ENV MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
ARG MYSQL_DATABASE
ENV MYSQL_DATABASE=${MYSQL_DATABASE}
ARG MYSQL_USER
ENV MYSQL_USER=${MYSQL_USER}
ARG MYSQL_PASSWORD
ENV MYSQL_PASSWORD=${MYSQL_PASSWORD}
ARG MYSQL_FORCE_INIT
ENV MYSQL_FORCE_INIT=${MYSQL_FORCE_INIT}

COPY ./tools/init.sh /docker-entrypoint-initdb.d/
RUN chmod +x /docker-entrypoint-initdb.d/init.sh

EXPOSE 3306

CMD ["/docker-entrypoint-initdb.d/init.sh"]