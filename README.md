# MiniRAG Enhanced

A unified Docker solution combining [MiniRAG](https://github.com/HKUDS/MiniRAG) with extended features from [LightRAG](https://github.com/HKUDS/LightRAG), providing an optimized RAG system for small LLMs with web UI, Neo4j, PostgreSQL and Ollama support.

## Overview

MiniRAG Enhanced merges the lightweight efficiency of MiniRAG with powerful features from LightRAG:

- **Streamlined RAG System**: Optimized for small language models
- **Web UI**: User-friendly interface for interacting with the system
- **Database Integration**: Neo4j and PostgreSQL support for knowledge storage
- **Ollama Connection**: Leverage local LLMs through Ollama
- **Docker Ready**: Containerized for easy deployment through GHCR

## Architecture

The system is split into two main containers:

1. **MiniRAG Backend**: Enhanced core RAG system with database connectors
2. **WebUI Frontend**: User interface for interacting with the system

Supporting services:
- Neo4j: Graph database for knowledge representation
- PostgreSQL: Relational database for structured data
- Ollama: Local LLM hosting

## Quick Start

### Using Pre-built Images

The easiest way to get started is using the pre-built images from GitHub Container Registry and [docker-compose(https://github.com/JoshuaRL/MiniRAG-Enhanced/blob/main/docker-compose.yml). The docker-compose file is configured to pull the latest pre-built images from this repository's GitHub Container Registry (GHCR) along with the necessary supporting services.

Be aware that the docker-compose sets Ollama to pull a couple small models so that this will be functional. You're welcome to change that, if you prefer others (I do), but be sure to change the .env file in the root of the WebUI container so that the system uses the correct model.

If you already have some of these services running, either in Docker or locally, feel free to point the rest their way. 

### Updating to New Versions

When the upstream MiniRAG or LightRAG repositories update:

1. This repo will automatically detect changes and build new images (for tracked branches)
2. To update your deployment:
   ```bash
   # Pull the latest docker-compose file
   git pull

   # Pull the latest images
   docker-compose pull

   # Restart the services
   docker-compose down
   docker-compose up -d
   ```
Or if you have some local automatic update method, like Watchtower, feel free to use that.

### Building Locally

If you prefer to build the images yourself:

```bash
# Clone this repository
git clone https://github.com/JoshuaRL/MiniRAG-Enhanced.git
cd MiniRAG-Enhanced

# Edit docker-compose.yml to use build instructions instead of images
# Uncomment the build sections and comment out the image lines

# Build and start the services
docker-compose up -d --build
```

## Configuration

### Versioning

You can specify which versions of MiniRAG and LightRAG to use:

1. For manual builds, edit the ARG values in `docker-compose.yml`
2. For GitHub Actions, trigger the workflow manually and specify versions

### Ports

- MiniRAG API: `7861`
- Web UI: `3000`
- Neo4j: `7474` (browser), `7687` (bolt)
- PostgreSQL: `5432`
- Ollama: `11434`

## Usage

1. Access the Web UI at `http://localhost:3000`
2. Access Neo4j Browser at `http://localhost:7474`
3. API endpoints are available at `http://localhost:7861`

## Development

### Directory Structure

```
MiniRAG-Enhanced/
├── Dockerfile.minirag       # MiniRAG backend Dockerfile
├── Dockerfile.webui         # WebUI frontend Dockerfile
├── docker-compose.yml       # Service orchestration
├── .github/workflows/       # GitHub Actions for CI/CD
│   ├── build-minirag.yml    # Workflow for MiniRAG container
│   └── build-webui.yml      # Workflow for WebUI container
├── data/                    # Persistent data volume
└── config/                  # Configuration files
```

## Connecting to Existing Services

If you already have Ollama, Neo4j, or PostgreSQL running, you can modify the docker-compose file to use those instead:

### Using External Ollama

```yaml
services:
  minirag:
    # ... other settings ...
    environment:
      - OLLAMA_BASE_URL=http://your-ollama-host:11434
    # ... other settings ...

  # Comment out or remove the ollama service section
  # ollama:
  #   image: ollama/ollama:latest
  #   ...
```

### Using External Neo4j

```yaml
services:
  minirag:
    # ... other settings ...
    environment:
      - NEO4J_URI=bolt://your-neo4j-host:7687
      - NEO4J_USER=your-username
      - NEO4J_PASSWORD=your-password
    # ... other settings ...

  # Comment out or remove the neo4j service section
  # neo4j:
  #   image: neo4j:5.11
  #   ...
```

### Using External PostgreSQL

```yaml
services:
  minirag:
    # ... other settings ...
    environment:
      - POSTGRES_URI=postgresql://your-user:your-password@your-postgres-host:5432/your-db
    # ... other settings ...

  # Comment out or remove the postgres service section
  # postgres:
  #   image: postgres:15
  #   ...
```

##Ollama Emulation
LightRAG provides Ollama-compatible interfaces, aiming to emulate LightRAG as an Ollama chat model. This allows AI chat frontends supporting Ollama, such as Open WebUI, to access LightRAG easily.

Connect Open WebUI to LightRAG
After starting the lightrag-server, you can add an Ollama-type connection in the Open WebUI admin panel. And then a model named lightrag:latest will appear in Open WebUI's model management interface. Users can then send queries to LightRAG through the chat interface. You should install LightRAG as a service for this use case.

Open WebUI uses an LLM to do the session title and session keyword generation task. So the Ollama chat completion API detects and forwards OpenWebUI session-related requests directly to the underlying LLM. See the [LightRAG Server documentation](https://github.com/HKUDS/LightRAG/tree/main/lightrag/api) for more informaion, as well as other runtime variables to be added to the .env file.

## Credits

MiniRAG Enhanced builds upon these excellent open-source projects:

- [MiniRAG](https://github.com/HKUDS/MiniRAG) - Compact RAG for small LLMs
- [LightRAG](https://github.com/HKUDS/LightRAG) - Lightweight RAG with extensive features
- [Ollama](https://github.com/ollama/ollama) - Run large language models locally
- [PostgreSQL](https://github.com/postgres/postgres) - Advanced open source relational database
- [Neo4j](https://github.com/neo4j/neo4j) - Graph database platform

## License

MIT License - See [LICENSE](LICENSE) for details
