FROM n8nio/n8n:1.95.3

USER root

# Instala wget, unzip y libaio en Alpine
RUN apk add --no-cache wget unzip libaio

# Descarga el ZIP del Oracle Instant Client (ajusta la URL si cambias de versión)
ENV ORACLE_INSTANT_CLIENT_URL="https://download.oracle.com/otn_software/linux/instantclient/instantclient-basiclite-linux.x64-21.12.0.0.0dbru.zip"
ENV ORACLE_INSTANT_CLIENT_ZIP_NAME="instantclient-basiclite-linux.x64-21.12.0.0.0dbru.zip"

RUN mkdir -p /opt/oracle && \
    wget -O /opt/oracle/${ORACLE_INSTANT_CLIENT_ZIP_NAME} ${ORACLE_INSTANT_CLIENT_URL} && \
    cd /opt/oracle && \
    unzip ${ORACLE_INSTANT_CLIENT_ZIP_NAME} && \
    rm ${ORACLE_INSTANT_CLIENT_ZIP_NAME} && \
    ln -s /opt/oracle/instantclient_* /opt/oracle/instantclient

ENV LD_LIBRARY_PATH=/opt/oracle/instantclient
ENV PATH=$LD_LIBRARY_PATH:$PATH

# Instala el nodo Oracle y oracledb globalmente
RUN npm install -g n8n-nodes-oracle oracledb

# Configura n8n para encontrar el nodo personalizado
ENV N8N_CUSTOM_EXTENSIONS="/usr/local/lib/node_modules/n8n-nodes-oracle"

USER node
