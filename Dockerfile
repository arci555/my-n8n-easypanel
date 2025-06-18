FROM n8nio/n8n:1.95.3

USER root

# Copia el cliente Oracle Instant Client desde una imagen pública
COPY --from=ghcr.io/oracle/oraclelinux8-instantclient:21 /usr/lib/oracle /usr/lib/oracle

RUN apk update && apk add --no-cache libaio libnsl

ENV LD_LIBRARY_PATH=/usr/lib/oracle/21/client64/lib
ENV PATH=/usr/lib/oracle/21/client64/bin:$PATH

RUN npm install -g n8n-nodes-oracle-database-parameterization

USER node
