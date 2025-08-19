# Railway Deployment Configurations

This directory contains complete Railway deployment configurations for all microservices in the project.

## 🏗️ Structure

```
railway-configs/
├── orchestrator/           # Main orchestration service
│   ├── railway.json       # Railway configuration
│   ├── Dockerfile         # Container definition
│   └── .env.example       # Environment variables template
├── qdrant-integration/     # Vector database integration
│   ├── railway.json
│   ├── Dockerfile
│   └── .env.example
├── notion-sync/           # Notion synchronization service
│   ├── railway.json
│   ├── Dockerfile
│   └── .env.example
├── scheduler/             # Job scheduling service
│   ├── railway.json
│   ├── Dockerfile
│   └── .env.example
└── notifications/         # Notification management service
    ├── railway.json
    ├── Dockerfile
    └── .env.example
```

## 🚀 Services Overview

### 1. **Orchestrator** (Port: 8000)
- **Purpose**: Main coordination service for all microservices
- **Dependencies**: PostgreSQL, Redis
- **Key Features**: API gateway, service coordination, authentication

### 2. **Qdrant Integration** (Port: 8001)
- **Purpose**: Vector database operations and embeddings management
- **Dependencies**: Qdrant vector database
- **Key Features**: Document indexing, similarity search, vector operations

### 3. **Notion Sync** (Port: 8002)
- **Purpose**: Synchronization with Notion workspace
- **Dependencies**: Notion API, PostgreSQL
- **Key Features**: Document sync, content parsing, webhook handling

### 4. **Scheduler** (Port: 8003)
- **Purpose**: Job scheduling and cron management
- **Dependencies**: PostgreSQL, Redis
- **Key Features**: Cron jobs, task scheduling, job monitoring

### 5. **Notifications** (Port: 8004)
- **Purpose**: Multi-channel notification system
- **Dependencies**: PostgreSQL, Redis
- **Key Features**: Email, Slack, Telegram notifications

## 🛠️ Deployment Instructions

### Prerequisites

1. **Install Railway CLI**:
   ```bash
   npm install -g @railway/cli
   ```

2. **Login to Railway**:
   ```bash
   railway login
   ```

3. **Create Railway Project** (if not exists):
   ```bash
   railway create
   ```

### 🚂 Quick Deploy All Services

Use the automated deployment script:

```bash
# Deploy all services
./scripts/deploy-all.sh

# Deploy specific service
./scripts/deploy-all.sh -s orchestrator

# Check status of deployed services
./scripts/deploy-all.sh -c

# Show help
./scripts/deploy-all.sh -h
```

### 📋 Manual Deployment

To deploy a specific service manually:

```bash
# Navigate to service directory
cd railway-configs/orchestrator

# Deploy to Railway
railway deploy

# Check deployment status
railway status

# View logs
railway logs
```

## ⚙️ Environment Configuration

### 1. Copy Environment Templates

For each service, copy and customize the environment file:

```bash
# Example for orchestrator
cp railway-configs/orchestrator/.env.example railway-configs/orchestrator/.env
```

### 2. Required Environment Variables

Each service has specific environment variables that need to be configured:

#### **Orchestrator Service**
- `DATABASE_URL`: PostgreSQL connection string
- `REDIS_URL`: Redis connection string
- `JWT_SECRET`: Secret for JWT token generation
- `API_KEY`: Service API key

#### **Qdrant Integration Service**
- `QDRANT_URL`: Qdrant database URL
- `QDRANT_API_KEY`: Qdrant API key
- `ORCHESTRATOR_API_KEY`: API key for orchestrator communication

#### **Notion Sync Service**
- `NOTION_API_KEY`: Notion integration token
- `NOTION_DATABASE_ID`: Target Notion database ID
- `DATABASE_URL`: PostgreSQL connection string

#### **Scheduler Service**
- `DATABASE_URL`: PostgreSQL connection string
- `REDIS_URL`: Redis connection string for job queue
- Service URLs for all integrated services

#### **Notifications Service**
- Email: `SMTP_SERVER`, `SMTP_USERNAME`, `SMTP_PASSWORD`
- Slack: `SLACK_BOT_TOKEN`, `SLACK_SIGNING_SECRET`
- Telegram: `TELEGRAM_BOT_TOKEN`, `TELEGRAM_CHAT_ID`
- `DATABASE_URL`: PostgreSQL connection string

### 3. Set Environment Variables in Railway

```bash
# Set environment variable for a service
railway variables set VARIABLE_NAME=value

# Set multiple variables from .env file
railway variables set --from .env
```

## 🔗 Service Dependencies

### Database Requirements
- **PostgreSQL**: Required for orchestrator, notion-sync, scheduler, notifications
- **Redis**: Required for orchestrator, scheduler, notifications (caching & job queue)
- **Qdrant**: Required for qdrant-integration (vector database)

### Inter-Service Communication
Services communicate via HTTP APIs on the following ports:
- Orchestrator: 8000 (main API gateway)
- Qdrant Integration: 8001
- Notion Sync: 8002
- Scheduler: 8003
- Notifications: 8004

## 📊 Monitoring & Health Checks

Each service includes:
- **Health Check Endpoint**: `/health`
- **Automatic Restart**: On failure with max 10 retries
- **Resource Monitoring**: CPU, memory, response times
- **Logging**: Structured logging with configurable levels

## 🔧 Customization

### Dockerfile Modifications
Each `Dockerfile` can be customized for specific service requirements:
- Add additional system dependencies
- Modify Python version or base image
- Adjust security settings
- Add custom build steps

### Railway Configuration
Each `railway.json` can be customized:
- Adjust resource allocation
- Modify health check settings
- Change restart policies
- Configure build settings

## 📝 Notes

1. **Resource Allocation**: Each service is configured with 1 replica by default
2. **Health Checks**: All services have health checks on `/health` endpoint
3. **Security**: Services run with non-root user for security
4. **Networking**: Services communicate via internal Railway network
5. **Persistent Storage**: Database connections are configured via environment variables

## 🆘 Troubleshooting

### Common Issues

1. **Deployment Fails**:
   - Check Railway CLI is installed and updated
   - Verify you're logged in: `railway whoami`
   - Ensure all required files exist in service directory

2. **Service Won't Start**:
   - Check environment variables are set correctly
   - Verify database connections
   - Review service logs: `railway logs`

3. **Inter-Service Communication Issues**:
   - Ensure all services are deployed and running
   - Check service URLs in environment variables
   - Verify API keys are correct

### Getting Help

- Check Railway documentation: https://docs.railway.app
- View service logs: `railway logs`
- Check service status: `railway status`
- Use the deployment script help: `./scripts/deploy-all.sh -h`