FROM n8nio/n8n:1.95.3

USER root

# Instala wget, unzip, libaio y libnsl en Alpine Linux (base de n8n)
RUN apk add --no-cache wget unzip libaio libnsl

# Define la URL y el nombre del ZIP de Oracle Instant Client
ENV ORACLE_INSTANT_CLIENT_URL="https://download.oracle.com/otn_software/linux/instantclient/instantclient-basiclite-linux.x64-21.12.0.0.0dbru.zip"
ENV ORACLE_INSTANT_CLIENT_ZIP_NAME="instantclient-basiclite-linux.x64-21.12.0.0.0dbru.zip"

# Descarga y descomprime el Oracle Instant Client, y crea enlaces simbólicos necesarios
RUN mkdir -p /opt/oracle && \
    wget -O /opt/oracle/${ORACLE_INSTANT_CLIENT_ZIP_NAME} ${ORACLE_INSTANT_CLIENT_URL} && \
    cd /opt/oracle && \
    unzip ${ORACLE_INSTANT_CLIENT_ZIP_NAME} && \
    rm ${ORACLE_INSTANT_CLIENT_ZIP_NAME} && \
    ln -s /opt/oracle/instantclient_* /opt/oracle/instantclient && \
    ln -s /usr/lib/libnsl.so.3 /usr/lib/libnsl.so.1

# Configura las variables de entorno para Oracle Instant Client
ENV LD_LIBRARY_PATH=/opt/oracle/instantclient
ENV PATH=$LD_LIBRARY_PATH:$PATH

# Instala el nodo Oracle y oracledb globalmente
RUN npm install -g n8n-nodes-oracle oracledb

# Configura n8n para detectar el nodo personalizado
ENV N8N_CUSTOM_EXTENSIONS="/usr/local/lib/node_modules/n8n-nodes-oracle"

USER node

