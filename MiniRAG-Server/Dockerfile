## MiniRAG Server Dockerfile
# Taken from HKUDS LightRAG, LightRAG Server, and MiniRAG
# For more info see https://github.com/HKUDS

# Base stage with Python slim and build dependencies
FROM python:3.11-slim as builder

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    build-essential \
    pkg-config \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

ENV PATH="/root/.cargo/bin:${PATH}"

# Clone repositories with specific versions
ARG MINIRAG_VERSION=main
ARG LIGHTRAG_VERSION=main

RUN git clone -b ${MINIRAG_VERSION} https://github.com/HKUDS/MiniRAG.git /app/MiniRAG \
    && git clone -b ${LIGHTRAG_VERSION} https://github.com/HKUDS/LightRAG.git /app/LightRAG

# Install MiniRAG dependencies
WORKDIR /app/MiniRAG
RUN pip install --no-cache-dir -e .

# Install additional dependencies for database connections and Ollama
WORKDIR /app
RUN pip install --no-cache-dir \
    neo4j-driver \
    psycopg2-binary \
    httpx \
    fastapi \
    uvicorn \
    python-dotenv \
    sqlalchemy

# Create necessary directories for connectors
RUN mkdir -p /app/MiniRAG/minirag/connectors/{ollama,neo4j,postgresql}

# Copy connectors from LightRAG to MiniRAG
RUN cp -r /app/LightRAG/lightrag/connectors/ollama/* /app/MiniRAG/minirag/connectors/ollama/ || true \
    && cp -r /app/LightRAG/lightrag/connectors/neo4j/* /app/MiniRAG/minirag/connectors/neo4j/ || true \
    && cp -r /app/LightRAG/lightrag/connectors/postgresql/* /app/MiniRAG/minirag/connectors/postgresql/ || true

# Create the API-related modules to enable WebUI connection
WORKDIR /app/MiniRAG
RUN mkdir -p minirag/api \
    && cp -r /app/LightRAG/lightrag/api/routes /app/MiniRAG/minirag/api/ || true \
    && cp -r /app/LightRAG/lightrag/api/schemas /app/MiniRAG/minirag/api/ || true

# Create configuration directories
RUN mkdir -p /app/MiniRAG/config
RUN mkdir -p /app/MiniRAG/data

# Set Python path to include the minirag directory
ENV PYTHONPATH=/app/MiniRAG

# Create the app.py entry point with authentication and Ollama emulation
WORKDIR /app/MiniRAG
COPY api_entrypoint.py minirag/app/app.py

# Final stage
FROM python:3.11-slim

WORKDIR /app/MiniRAG

# Copy necessary files from builder
COPY --from=builder /root/.local /root/.local

# Conditionally copy .env.example to .env only if .env doesn't exist
RUN if [ ! -f "/app/.env" ]; then \
    cp /app/.env.example /app/.env; \
  fi

# Expose the default port for FastAPI (or the port your app uses)
EXPOSE 7861

# Set entrypoint to run the FastAPI application using Uvicorn with authentication and Ollama emulation
CMD ["uvicorn", "minirag.app.app:app", "--host", "0.5", "--port", "9621"]
