## MiniRAG WebUI Dockerfile
# Taken from HKUDS LightRAG, LightRAG Server, and MiniRAG
# For more info see https://github.com/HKUDS

# Use Node.js as base image
FROM node:18-alpine

# Build argument for repository version
ARG LIGHTRAG_VERSION=main

WORKDIR /app

# Install system dependencies
RUN apk add --no-cache git

# Clone LightRAG repository with specific version to get the WebUI code
RUN git clone -b ${LIGHTRAG_VERSION} https://github.com/HKUDS/LightRAG.git /app/LightRAG

# Set up the web UI frontend
WORKDIR /app/LightRAG/lightrag/api/server

# Install dependencies
RUN npm install

# Build the frontend
RUN npm run build

# Modify the server configuration to connect to MiniRAG API
RUN mkdir -p /app/config

# Create a configuration file to point to MiniRAG API
RUN echo '{\n\
  "apiUrl": "http://minirag:7861"\n\
}' > /app/config/server-config.json

# Expose the port for the web UI
EXPOSE 3000

# Start the web server
CMD ["npm", "run", "start"]
