FROM debian:buster

RUN apt-get update -y && apt upgrade -y

RUN apt-get install mariadb-server -y

COPY ./conf/50_server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY ./tools/script.sh /script.sh

RUN chmod 755 script.sh
RUN chmod 0444 /etc/mysql/mariadb.conf.d/50-server.cnf

CMD ["/script.sh"]

EXPOSE 3306

#CMD /usr/bin/mysqld_safe

#CMD service mysql start