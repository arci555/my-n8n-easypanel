FROM n8nio/n8n:latest

USER root

# Instala dependencias de Alpine Linux y wget
RUN apk add --no-cache libaio unzip wget

# DESCARGA el Instant Client desde una URL directa (si tienes acceso) o usa COPY si subes el ZIP manualmente
# Si tienes que usar COPY:
# COPY instantclient-basiclite-linux.x64-21.12.0.0.0dbru.zip /opt/oracle/
# Si puedes descargarlo, usa:
# RUN wget -O /opt/oracle/instantclient-basiclite-linux.x64-21.12.0.0.0dbru.zip "URL_DIRECTA_DEL_ZIP"

# Descomprime e instala el Instant Client
RUN cd /opt/oracle && \
    unzip instantclient-basiclite-linux.x64-21.12.0.0.0dbru.zip && \
    rm instantclient-basiclite-linux.x64-21.12.0.0.0dbru.zip && \
    ln -s /opt/oracle/instantclient_* /opt/oracle/instantclient

# Configura las variables de entorno para Oracle Instant Client
ENV LD_LIBRARY_PATH=/opt/oracle/instantclient
ENV PATH=$LD_LIBRARY_PATH:$PATH

# Instala el nodo comunitario de Oracle para n8n (el mismo que usas en local)
RUN npm_config_user=root npm install -g n8n-nodes-oracle

# Habilita la extensión personalizada
ENV N8N_CUSTOM_EXTENSIONS="/usr/local/lib/node_modules/n8n-nodes-oracle"

# Instala el módulo oracledb globalmente (opcional, pero recomendado)
RUN npm install -g oracledb

USER node
