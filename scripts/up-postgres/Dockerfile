ARG postgres_version

FROM library/postgres:${postgres_version}
ENV POSTGRES_PASSWORD 01
ENV POSTGRES_HOST_AUTH_METHOD trust

COPY /* /docker-entrypoint-initdb.d/
RUN chown -R postgres:postgres /docker-entrypoint-initdb.d/

