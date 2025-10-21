FROM n8nio/n8n:1.115.3

USER root

RUN apk add --no-cache libaio unzip wget
RUN apk add --no-cache iputils

RUN mkdir -p /opt/oracle && \
    wget -O /opt/oracle/instantclient-basiclite-linux.x64-21.12.0.0.0dbru.zip "https://www.dropbox.com/scl/fi/tiunqwm6s9bwdde3wednw/instantclient-basiclite-linux.x64-21.12.0.0.0dbru.zip?rlkey=kgbdvye002kl5uib8y6vvfm8y&st=ggg9llr1&dl=1"

RUN cd /opt/oracle && \
    unzip instantclient-basiclite-linux.x64-21.12.0.0.0dbru.zip && \
    rm instantclient-basiclite-linux.x64-21.12.0.0.0dbru.zip && \
    ln -s /opt/oracle/instantclient_* /opt/oracle/instantclient

ENV LD_LIBRARY_PATH=/opt/oracle/instantclient
ENV PATH=$LD_LIBRARY_PATH:$PATH

RUN npm install -g n8n-nodes-oracle
ENV N8N_CUSTOM_EXTENSIONS="/usr/local/lib/node_modules/n8n-nodes-oracle"
RUN npm install -g oracledb

# Instala git para descargar los nodos
RUN apk add --no-cache git

# Crea la carpeta "custom" si no existe y descarga los nodos LlamaCloud
RUN mkdir -p /home/node/.n8n/custom && \
    git clone --depth 1 https://github.com/run-llama/n8n-llamacloud.git /tmp/n8n-llamacloud && \
    cd /tmp/n8n-llamacloud && \
    npm install && \
    npm run build && \
    cp -r dist/* /home/node/.n8n/custom/ && \
    rm -rf /tmp/n8n-llamacloud

USER node
