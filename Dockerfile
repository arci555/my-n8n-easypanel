FROM n8nio/n8n:1.95.3

USER root

# Copia el cliente Oracle Instant Client desde una imagen oficial de Oracle
COPY --from=ghcr.io/oracle/oraclelinux8-instantclient:21 /usr/lib/oracle /usr/lib/oracle

# Instala dependencias necesarias para Alpine
RUN apk update && apk add --no-cache libaio libnsl

# Instala el nodo Oracle para n8n de forma global
RUN npm_config_user=root npm install -g n8n-nodes-oracle-database-parameterization

# Habilita la carga de extensiones personalizadas en n8n
ENV N8N_CUSTOM_EXTENSIONS="/usr/local/lib/node_modules/n8n-nodes-oracle-database-parameterization"

# Configura las variables de entorno de Oracle
ENV LD_LIBRARY_PATH=/usr/lib/oracle/21/client64/lib
ENV PATH=/usr/lib/oracle/21/client64/bin:$PATH

USER node
