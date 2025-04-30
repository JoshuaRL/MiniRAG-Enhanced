# MiniRAG Enhanced Environment Variables

### Authentication Settings
JWT_SECRET=your-secret-key-here
TOKEN_EXPIRE_HOURS=4
LIGHTRAG_API_KEY=your-secure-api-key

### LLM Configuration
LLM_BINDING=ollama
LLM_MODEL=llama3.2:1b-instruct-q8_0
OLLAMA_BASE_URL=http://ollama:11434

### Embedding Configuration
EMBEDDING_BINDING=ollama
EMBEDDING_MODEL=nomic-embed-text:latest
EMBEDDING_DIM=2048

### Database Connections
NEO4J_URI=bolt://neo4j:7687
NEO4J_USER=neo4j
NEO4J_PASSWORD=my_password123

POSTGRES_URI=postgresql://postgres:postgres@localhost:5432/lightrag

### Server Configuration
PORT=7861
HOST=0.0.0.0
WORKERS=2
MAX_PARALLEL_INSERT=2
MAX_ASYNC=4
MAX_TOKENS=8192
