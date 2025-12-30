FROM n8nio/n8n:2.1.4

USER root

# Instalar dependencias con apt, no con apk
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    git python3 make g++ \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /data/custom

RUN git clone --depth 1 https://github.com/run-llama/n8n-llamacloud.git /tmp/n8n-llamacloud

WORKDIR /tmp/n8n-llamacloud
RUN npm install
RUN npm run build || true

RUN cp -r /tmp/n8n-llamacloud/dist/* /data/custom/

WORKDIR /
RUN rm -rf /tmp/n8n-llamacloud

ENV N8N_CUSTOM_EXTENSIONS="/data/custom"

USER node





