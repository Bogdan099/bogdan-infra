#!/bin/bash

# Railway Deployment Script for Orchestrator Service
# Этот скрипт выполняет деплой orchestrator сервиса на Railway

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚂 Starting Railway deployment for Orchestrator service...${NC}"
echo ""

# Check if Railway CLI is installed
if ! command -v railway &> /dev/null; then
    echo -e "${YELLOW}📦 Installing Railway CLI...${NC}"
    npm install -g @railway/cli
fi

# Check Railway CLI version
echo -e "${GREEN}✅ Railway CLI version: $(railway --version)${NC}"

# Navigate to orchestrator directory
cd railway-configs/orchestrator

echo -e "${BLUE}📁 Current directory: $(pwd)${NC}"
echo -e "${BLUE}📋 Files in directory:${NC}"
ls -la

# Check if user is logged in to Railway
echo -e "${YELLOW}🔐 Checking Railway authentication...${NC}"
if ! railway whoami &> /dev/null; then
    echo -e "${YELLOW}⚠️  You are not logged in to Railway.${NC}"
    echo -e "${BLUE}Please login using one of these methods:${NC}"
    echo ""
    echo -e "${YELLOW}Method 1: Browser login${NC}"
    echo "railway login"
    echo ""
    echo -e "${YELLOW}Method 2: Token login (if you have RAILWAY_TOKEN)${NC}"
    echo "export RAILWAY_TOKEN='your-token-here'"
    echo "railway login"
    echo ""
    echo -e "${YELLOW}Method 3: Browserless login${NC}"
    echo "railway login --browserless"
    echo "(Follow the URL and pairing code instructions)"
    echo ""
    exit 1
fi

# Initialize Railway project
echo -e "${BLUE}🚀 Initializing Railway project...${NC}"
if [ ! -f ".railway" ]; then
    railway init --name orchestrator-service
else
    echo -e "${GREEN}✅ Railway project already initialized${NC}"
fi

# Check if railway.json is valid
echo -e "${BLUE}📋 Validating Railway configuration...${NC}"
if [ ! -f "railway.json" ]; then
    echo -e "${RED}❌ railway.json not found${NC}"
    exit 1
fi

if [ ! -f "Dockerfile" ]; then
    echo -e "${RED}❌ Dockerfile not found${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Configuration files validated${NC}"

# Deploy the service
echo -e "${BLUE}🚀 Deploying to Railway...${NC}"
railway deploy --detach

echo -e "${GREEN}✅ Deployment initiated${NC}"

# Check deployment status
echo -e "${BLUE}📊 Checking deployment status...${NC}"
sleep 10  # Wait a bit for deployment to start

railway status

# Get service URL
echo -e "${BLUE}🔗 Getting service URL...${NC}"
SERVICE_URL=$(railway domain || echo "No domain configured")

if [ "$SERVICE_URL" != "No domain configured" ]; then
    echo -e "${GREEN}🎉 Orchestrator service deployed successfully!${NC}"
    echo -e "${BLUE}Service URL: ${GREEN}$SERVICE_URL${NC}"
    echo ""
    echo -e "${BLUE}Health check: ${GREEN}$SERVICE_URL/health${NC}"
    echo ""
    
    # Test health endpoint
    echo -e "${BLUE}🔍 Testing health endpoint...${NC}"
    if curl -f "$SERVICE_URL/health" &> /dev/null; then
        echo -e "${GREEN}✅ Health check passed${NC}"
    else
        echo -e "${YELLOW}⚠️  Health check failed (service might still be starting)${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Service deployed but no domain configured${NC}"
    echo -e "${BLUE}To configure domain run: ${YELLOW}railway domain${NC}"
fi

# Show logs
echo -e "${BLUE}📝 Recent logs:${NC}"
railway logs --tail 20

echo ""
echo -e "${GREEN}🎉 Deployment completed!${NC}"
echo -e "${BLUE}To view logs: ${YELLOW}railway logs${NC}"
echo -e "${BLUE}To check status: ${YELLOW}railway status${NC}"