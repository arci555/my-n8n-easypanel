FROM n8nio/n8n:1.95.3
USER root
RUN npm install -g n8n-nodes-oracle-database

USER node
