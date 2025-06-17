# Usa la imagen base de n8n
FROM n8nio/n8n:1.95.3

# Cambia al usuario root para instalar dependencias del sistema
USER root

# --- Inicio de la sección para Oracle Instant Client ---
# Instala wget para descargar el archivo ZIP
RUN apk add --no-cache wget

# Define la URL de descarga de tu archivo ZIP de Oracle Instant Client
ENV ORACLE_INSTANT_CLIENT_URL="https://drive.google.com/uc?export=download&id=1kpENp5x21ZgCnmvcsbTOz9qpSkc2d__P"
ENV ORACLE_INSTANT_CLIENT_ZIP_NAME="instantclient-basiclite-linux.x64-21.12.0.0.0dbru.zip"

# Crea el directorio y descarga el archivo ZIP
RUN mkdir -p /opt/oracle && \
    wget -O /opt/oracle/${ORACLE_INSTANT_CLIENT_ZIP_NAME} ${ORACLE_INSTANT_CLIENT_URL}

# Instala dependencias de Alpine Linux necesarias (libaio para Oracle, unzip para descomprimir)
# Descomprime el Instant Client, borra el ZIP y crea un enlace simbólico para simplificar la ruta
RUN apk add --no-cache libaio unzip && \
    cd /opt/oracle && \
    unzip ${ORACLE_INSTANT_CLIENT_ZIP_NAME} && \
    rm ${ORACLE_INSTANT_CLIENT_ZIP_NAME} && \
    ln -s /opt/oracle/instantclient_* /opt/oracle/instantclient

# Configura las variables de entorno para que el sistema encuentre las librerías de Oracle
ENV LD_LIBRARY_PATH=/opt/oracle/instantclient
ENV PATH=$LD_LIBRARY_PATH:$PATH
# --- Fin de la sección para Oracle Instant Client ---

# Instala el nodo comunitario para Oracle (o el que estés usando)
RUN npm install -g n8n-nodes-oracle
RUN npm install -g oracledb

# Configura n8n para que encuentre el nodo comunitario (ajusta la ruta si tu nodo usa otra)
ENV N8N_CUSTOM_EXTENSIONS="/usr/local/lib/node_modules/n8n-nodes-oracle"

# Vuelve a cambiar al usuario 'node' para ejecutar n8n con privilegios limitados (seguridad)
USER node
