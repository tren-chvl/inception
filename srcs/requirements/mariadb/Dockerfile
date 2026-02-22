FROM alpine:3.19

RUN apk update && apk add --no-cache mariadb mariadb-client mariadb-server-utils


RUN mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld

COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["/entrypoint.sh"]
CMD ["mysqld", "--user=mysql"]
