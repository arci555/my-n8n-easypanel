FROM n8nio/n8n:2.1.4

USER root

# Instalar dependencias en Alpine
RUN apk add --no-cache \
    libaio \
    unzip \
    wget \
    python3 \
    make \
    g++ \
    git \
    iputils

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

RUN npm install -g typescript gulp

RUN mkdir -p /data/custom \
 && git clone --depth 1 https://github.com/run-llama/n8n-llamacloud.git /tmp/n8n-llamacloud

WORKDIR /tmp/n8n-llamacloud
RUN npm install
RUN npm install gulp gulp-cli
RUN npx gulp build:icons || true
RUN npm run build || true

RUN cp -r /tmp/n8n-llamacloud/dist/* /data/custom/
WORKDIR /
RUN rm -rf /tmp/n8n-llamacloud

USER node
WORKDIR /


