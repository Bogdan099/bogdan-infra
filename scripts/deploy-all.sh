#!/bin/bash

# Railway Deployment Script for All Services
# This script deploys all services to Railway platform

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Service configuration
SERVICES=(
    "orchestrator"
    "qdrant-integration"
    "notion-sync"
    "scheduler"
    "notifications"
)

# Configuration
PROJECT_ROOT=$(pwd)
RAILWAY_CONFIG_DIR="railway-configs"
DEPLOY_TIMEOUT=300  # 5 minutes

echo -e "${BLUE}🚂 Starting Railway deployment for all services...${NC}"
echo ""

# Check if Railway CLI is installed
if ! command -v railway &> /dev/null; then
    echo -e "${RED}❌ Railway CLI is not installed. Please install it first:${NC}"
    echo "npm install -g @railway/cli"
    exit 1
fi

# Check if user is logged in to Railway
if ! railway whoami &> /dev/null; then
    echo -e "${YELLOW}⚠️  You are not logged in to Railway. Please login:${NC}"
    echo "railway login"
    exit 1
fi

# Function to deploy a service
deploy_service() {
    local service=$1
    local service_dir="$RAILWAY_CONFIG_DIR/$service"
    
    echo -e "${BLUE}📦 Deploying $service...${NC}"
    
    # Check if service directory exists
    if [ ! -d "$service_dir" ]; then
        echo -e "${RED}❌ Service directory $service_dir not found${NC}"
        return 1
    fi
    
    # Check if required files exist
    if [ ! -f "$service_dir/railway.json" ]; then
        echo -e "${RED}❌ railway.json not found for $service${NC}"
        return 1
    fi
    
    if [ ! -f "$service_dir/Dockerfile" ]; then
        echo -e "${RED}❌ Dockerfile not found for $service${NC}"
        return 1
    fi
    
    # Create or link to Railway project
    cd "$service_dir"
    
    # Deploy the service
    echo -e "${YELLOW}🚀 Deploying $service to Railway...${NC}"
    
    if railway deploy --detach; then
        echo -e "${GREEN}✅ $service deployed successfully${NC}"
    else
        echo -e "${RED}❌ Failed to deploy $service${NC}"
        return 1
    fi
    
    cd "$PROJECT_ROOT"
    echo ""
}

# Function to check deployment status
check_deployment_status() {
    local service=$1
    local service_dir="$RAILWAY_CONFIG_DIR/$service"
    
    echo -e "${BLUE}🔍 Checking deployment status for $service...${NC}"
    
    cd "$service_dir"
    
    if railway status; then
        echo -e "${GREEN}✅ $service is running${NC}"
    else
        echo -e "${YELLOW}⚠️  $service status unclear${NC}"
    fi
    
    cd "$PROJECT_ROOT"
}

# Main deployment process
main() {
    echo -e "${YELLOW}📋 Services to deploy: ${SERVICES[*]}${NC}"
    echo ""
    
    # Ask for confirmation
    read -p "Do you want to proceed with deployment? (y/N): " -n 1 -r
    echo ""
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}❌ Deployment cancelled${NC}"
        exit 0
    fi
    
    # Deploy each service
    local failed_services=()
    local successful_services=()
    
    for service in "${SERVICES[@]}"; do
        if deploy_service "$service"; then
            successful_services+=("$service")
        else
            failed_services+=("$service")
        fi
        
        # Wait a bit between deployments
        sleep 5
    done
    
    echo ""
    echo -e "${BLUE}📊 Deployment Summary:${NC}"
    echo ""
    
    if [ ${#successful_services[@]} -gt 0 ]; then
        echo -e "${GREEN}✅ Successfully deployed services:${NC}"
        for service in "${successful_services[@]}"; do
            echo "  - $service"
        done
    fi
    
    if [ ${#failed_services[@]} -gt 0 ]; then
        echo -e "${RED}❌ Failed to deploy services:${NC}"
        for service in "${failed_services[@]}"; do
            echo "  - $service"
        done
    fi
    
    echo ""
    
    # Check status of all deployed services
    if [ ${#successful_services[@]} -gt 0 ]; then
        echo -e "${BLUE}🔍 Checking deployment status...${NC}"
        echo ""
        
        for service in "${successful_services[@]}"; do
            check_deployment_status "$service"
        done
    fi
    
    echo ""
    
    if [ ${#failed_services[@]} -eq 0 ]; then
        echo -e "${GREEN}🎉 All services deployed successfully!${NC}"
    else
        echo -e "${YELLOW}⚠️  Some services failed to deploy. Check the errors above.${NC}"
        exit 1
    fi
}

# Function to show help
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -s, --service  Deploy specific service only"
    echo "  -c, --check    Check status of deployed services"
    echo ""
    echo "Services available: ${SERVICES[*]}"
    echo ""
    echo "Examples:"
    echo "  $0                           # Deploy all services"
    echo "  $0 -s orchestrator          # Deploy only orchestrator service"
    echo "  $0 -c                       # Check status of all services"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -s|--service)
            if [ -n "$2" ] && [[ " ${SERVICES[@]} " =~ " $2 " ]]; then
                deploy_service "$2"
                exit $?
            else
                echo -e "${RED}❌ Invalid or missing service name${NC}"
                echo "Available services: ${SERVICES[*]}"
                exit 1
            fi
            ;;
        -c|--check)
            echo -e "${BLUE}🔍 Checking status of all services...${NC}"
            for service in "${SERVICES[@]}"; do
                check_deployment_status "$service"
            done
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Unknown option: $1${NC}"
            show_help
            exit 1
            ;;
    esac
    shift
done

# Run main function if no arguments provided
main