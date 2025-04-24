## MiniRAG Server Dockerfile
# Taken from HKUDS LightRAG, LightRAG Server, and MiniRAG
# For more info see https://github.com/HKUDS

# Base image from NVIDIA for GPU support
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

# Build arguments for repository versions
ARG MINIRAG_VERSION=main
ARG LIGHTRAG_VERSION=main

WORKDIR /app

# System dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    wget \
    software-properties-common \
    build-essential \
    python3-dev \
    python3-pip \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Set Python to Python 3
RUN ln -sf /usr/bin/python3 /usr/bin/python
RUN ln -sf /usr/bin/pip3 /usr/bin/pip

# Clone repositories with specific versions
RUN git clone -b ${MINIRAG_VERSION} https://github.com/HKUDS/MiniRAG.git /app/MiniRAG \
    && git clone -b ${LIGHTRAG_VERSION} https://github.com/HKUDS/LightRAG.git /app/LightRAG

# Install MiniRAG dependencies
WORKDIR /app/MiniRAG
RUN pip install --no-cache-dir -e .

# Install additional dependencies for database connections and Ollama
RUN pip install --no-cache-dir \
    neo4j \
    psycopg2-binary \
    httpx \
    fastapi \
    uvicorn \
    python-dotenv \
    sqlalchemy

# Create necessary directories for connectors
RUN mkdir -p /app/MiniRAG/minirag/connectors/ollama \
    && mkdir -p /app/MiniRAG/minirag/connectors/neo4j \
    && mkdir -p /app/MiniRAG/minirag/connectors/postgresql

# Copy connectors from LightRAG to MiniRAG
WORKDIR /app
RUN cp -r /app/LightRAG/lightrag/connectors/ollama/* /app/MiniRAG/minirag/connectors/ollama/ || true
RUN cp -r /app/LightRAG/lightrag/connectors/neo4j/* /app/MiniRAG/minirag/connectors/neo4j/ || true
RUN cp -r /app/LightRAG/lightrag/connectors/postgresql/* /app/MiniRAG/minirag/connectors/postgresql/ || true

# Copy API-related modules to enable WebUI connection
RUN mkdir -p /app/MiniRAG/minirag/api
RUN cp -r /app/LightRAG/lightrag/api/routes /app/MiniRAG/minirag/api/ || true
RUN cp -r /app/LightRAG/lightrag/api/schemas /app/MiniRAG/minirag/api/ || true

# Create configuration directories
RUN mkdir -p /app/MiniRAG/config
RUN mkdir -p /app/MiniRAG/data

# Set environment variables
ENV PYTHONPATH=/app/MiniRAG
ENV OLLAMA_BASE_URL="http://ollama:11434"
ENV NEO4J_URI="bolt://neo4j:7687"
ENV NEO4J_USER="neo4j"
ENV NEO4J_PASSWORD="password"
ENV POSTGRES_URI="postgresql://postgres:postgres@postgres:5432/lightrag"

# Expose MiniRAG API port
EXPOSE 7861

# Set the working directory back to MiniRAG
WORKDIR /app/MiniRAG

# Add an entry point file to initialize the API
RUN echo 'import uvicorn\nfrom minirag.app import app\n\nif __name__ == "__main__":\n    uvicorn.run(app, host="0.0.0.0", port=7861)' > /app/MiniRAG/run_api.py

# Default command
CMD ["python", "run_api.py"]
