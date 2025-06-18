FROM n8nio/n8n:latest

USER root

RUN apk add --no-cache libaio unzip wget

RUN mkdir -p /opt/oracle && \
    wget -O /opt/oracle/instantclient-basiclite-linux.x64-21.12.0.0.0dbru.zip "https://www.dropbox.com/scl/fi/oh9imwc3x480d177oqxo3/instantclient-basiclite-linux.x64-21.12.0.0.0dbru.zip?rlkey=0gc6uj25sd03b1m9j10po67ij&st=ujdkj75x&dl=1"

RUN cd /opt/oracle && \
    unzip instantclient-basiclite-linux.x64-21.12.0.0.0dbru.zip && \
    rm instantclient-basiclite-linux.x64-21.12.0.0.0dbru.zip && \
    ln -s /opt/oracle/instantclient_* /opt/oracle/instantclient

ENV LD_LIBRARY_PATH=/opt/oracle/instantclient
ENV PATH=$LD_LIBRARY_PATH:$PATH

RUN npm install -g n8n-nodes-oracle
ENV N8N_CUSTOM_EXTENSIONS="/usr/local/lib/node_modules/n8n-nodes-oracle"
RUN npm install -g oracledb

USER node
