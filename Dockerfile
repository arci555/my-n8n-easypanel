FROM n8nio/n8n:latest

USER root

# Instala dependencias necesarias
RUN apk add --no-cache libaio unzip wget

# Descarga el Oracle Instant Client desde Dropbox (enlace directo)
RUN wget -O /opt/oracle/instantclient-basiclite-linux.x64-21.12.0.0.0dbru.zip "https://www.dropbox.com/scl/fi/oh9imwc3x480d177oqxo3/instantclient-basiclite-linux.x64-21.12.0.0.0dbru.zip?rlkey=0gc6uj25sd03b1m9j10po67ij&st=ujdkj75x&dl=1"

# Descomprime e instala el Instant Client
RUN cd /opt/oracle && \
    unzip instantclient-basiclite-linux.x64-21.12.0.0.0dbru.zip && \
    rm instantclient-basiclite-linux.x64-21.12.0.0.0dbru.zip && \
    ln -s /opt/oracle/instantclient_* /opt/oracle/instantclient

# Configura las variables de entorno para Oracle Instant Client
ENV LD_LIBRARY_PATH=/opt/oracle/instantclient
ENV PATH=$LD_LIBRARY_PATH:$PATH

# Instala el nodo comunitario para Oracle globalmente
RUN npm install -g n8n-nodes-oracle

# Configura n8n para que encuentre el nodo comunitario
ENV N8N_CUSTOM_EXTENSIONS="/usr/local/lib/node_modules/n8n-nodes-oracle"

# Instala el módulo oracledb globalmente (opcional pero recomendado)
RUN npm install -g oracledb

USER node
