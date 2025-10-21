FROM n8nio/n8n:1.115.3
USER root

# Oracle Client setup
RUN apk add --no-cache libaio unzip wget iputils
RUN mkdir -p /opt/oracle && \
    wget -O /opt/oracle/instantclient-basiclite-linux.x64-21.12.0.0.0dbru.zip "https://www.dropbox.com/scl/fi/tiunqwm6s9bwdde3wednw/instantclient-basiclite-linux.x64-21.12.0.0.0dbru.zip?rlkey=kgbdvye002kl5uib8y6vvfm8y&st=ggg9llr1&dl=1" && \
    cd /opt/oracle && \
    unzip instantclient-basiclite-linux.x64-21.12.0.0.0dbru.zip && \
    rm instantclient-basiclite-linux.x64-21.12.0.0.0dbru.zip && \
    ln -s /opt/oracle/instantclient_* /opt/oracle/instantclient

ENV LD_LIBRARY_PATH=/opt/oracle/instantclient
ENV PATH=$LD_LIBRARY_PATH:$PATH

# Oracle node
RUN npm install -g n8n-nodes-oracle oracledb

# Build dependencies
RUN apk add --no-cache python3 make g++ git
RUN npm install -g typescript gulp-cli

# LlamaCloud node
RUN mkdir -p /data/custom && \
    git clone --depth 1 https://github.com/run-llama/n8n-llamacloud.git /tmp/n8n-llamacloud

WORKDIR /tmp/n8n-llamacloud
RUN npm install && \
    npm install gulp && \
    npx rimraf dist && \
    tsc && \
    gulp build:icons && \
    cp -r /tmp/n8n-llamacloud/dist/* /data/custom/

# Configure custom extensions path
ENV N8N_CUSTOM_EXTENSIONS="/usr/local/lib/node_modules/n8n-nodes-oracle;/data/custom"

# Cleanup
WORKDIR /
RUN rm -rf /tmp/n8n-llamacloud

USER node
