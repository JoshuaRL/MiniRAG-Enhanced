## MiniRAG WebUI Dockerfile
# Taken from HKUDS LightRAG, LightRAG Server, and MiniRAG
# For more info see https://github.com/HKUDS

# Use Python slim as base image
FROM python:3.11-slim

# Install git and dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    && rm -rf /var/lib/apt/lists/*

# Clone LightRAG at specified version
WORKDIR /app
ARG LIGHTRAG_VERSION=main
RUN git clone https://github.com/HKUDS/LightRAG.git . && \
    git checkout ${LIGHTRAG_VERSION}

# Install the package
RUN pip install --no-cache-dir -e .

# Set environment variables
ENV FLASK_APP=lightrag.api.app
ENV FLASK_ENV=production

# Modify the server configuration to connect to MiniRAG API
RUN mkdir -p /app/config

# Create a configuration file to point to MiniRAG API
RUN echo '{\n\
  "apiUrl": "http://minirag:7861"\n\
}' > /app/config/server-config.json

# Create .env file in the root directory
RUN mkdir -p / && \
    echo "LLM_BINDING=ollama" >> /.env && \
    echo "LLM_MODEL=llama3.2:1b-instruct-q8_0" >> /.env && \
    echo "LLM_BINDING_HOST=http://ollama:11434" >> /.env && \
    echo "# LLM_BINDING_API_KEY=your_api_key" >> /.env && \
    echo "### Max tokens sent to LLM (based on your Ollama Server capacity)" >> /.env && \
    echo "MAX_TOKENS=8192" >> /.env && \
    echo "" >> /.env && \
    echo "EMBEDDING_BINDING=ollama" >> /.env && \
    echo "EMBEDDING_BINDING_HOST=http://localhost:11434" >> /.env && \
    echo "EMBEDDING_MODEL=nomic-embed-text:latest" >> /.env && \
    echo "EMBEDDING_DIM=2048" >> /.env && \
    echo "# EMBEDDING_BINDING_API_KEY=your_api_key" >> /env

# Expose the port the API will run on
EXPOSE 3000

# Start the web server
CMD ["lightrag-server"]
