#!/usr/bin/env python3
"""
Main entry point for the Orchestrator Service
Railway deployment ready FastAPI application
"""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import uvicorn
import os
from typing import Dict, Any

app = FastAPI(
    title="Orchestrator Service",
    description="Main coordination service for bogdan-infra microservices",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Configure properly in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def root() -> Dict[str, str]:
    """Root endpoint"""
    return {
        "message": "🚂 Orchestrator Service is running on Railway!",
        "status": "healthy",
        "service": "orchestrator",
        "version": "1.0.0"
    }

@app.get("/health")
async def health_check() -> Dict[str, Any]:
    """Health check endpoint for Railway"""
    return {
        "status": "healthy",
        "service": "orchestrator",
        "version": "1.0.0",
        "environment": os.getenv("RAILWAY_ENVIRONMENT", "development"),
        "timestamp": "2024-08-19T10:00:00Z"
    }

@app.get("/api/status")
async def api_status() -> Dict[str, Any]:
    """API status endpoint"""
    return {
        "api_status": "operational",
        "services": {
            "orchestrator": "running",
            "database": "pending",  # Will be configured later
            "redis": "pending",     # Will be configured later
        },
        "deployment": {
            "platform": "Railway",
            "environment": os.getenv("RAILWAY_ENVIRONMENT", "development"),
            "auto_deploy": True
        }
    }

if __name__ == "__main__":
    # Get port from Railway environment or default to 8000
    port = int(os.getenv("PORT", 8000))
    
    # Run with uvicorn
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=port,
        log_level="info",
        access_log=True
    )