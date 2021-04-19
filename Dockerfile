FROM ubuntu:latest
LABEL maintainer="patwiri@gmail.com"
# set timezone
ENV TZ=Africa/Nairobi
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
# install postgresql
RUN apt update && apt install -y wget curl software-properties-common postgresql-12 postgresql-client-12 postgresql-contrib-12
USER postgres
# create docker user
RUN    /etc/init.d/postgresql start &&\
    psql --command "CREATE USER docker WITH SUPERUSER PASSWORD '!QAZ!QAZ';" &&\
    createdb -O docker docker
# create data user
RUN    /etc/init.d/postgresql start &&\
    psql --command "CREATE USER data WITH SUPERUSER PASSWORD '@WSX@WSX';" &&\
    createdb -O data data
# allow from all
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/12/main/pg_hba.conf
RUN echo "listen_addresses='*'" >> /etc/postgresql/12/main/postgresql.conf
EXPOSE 5432
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]
CMD ["/usr/lib/postgresql/12/bin/postgres", "-D", "/var/lib/postgresql/12/main", "-c", "config_file=/etc/postgresql/12/main/postgresql.conf"]