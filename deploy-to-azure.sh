#!/bin/bash

# Azure Deployment Script
# This script helps you deploy your application to Azure App Service

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}Azure AI Search App Deployment Script${NC}\n"

# Check if Azure CLI is installed
if ! command -v az &> /dev/null
then
    echo -e "${RED}Azure CLI is not installed.${NC}"
    echo -e "${YELLOW}Please install it from: https://docs.microsoft.com/cli/azure/install-azure-cli${NC}"
    echo -e "${YELLOW}Or use Azure Cloud Shell: https://shell.azure.com${NC}\n"
    exit 1
fi

# Login to Azure
echo -e "${YELLOW}Logging into Azure...${NC}"
az login

# Get user inputs
read -p "Enter Resource Group name (or press Enter for 'azure-search-rg'): " RESOURCE_GROUP
RESOURCE_GROUP=${RESOURCE_GROUP:-azure-search-rg}

read -p "Enter App Service Plan name (or press Enter for 'azure-search-plan'): " APP_PLAN
APP_PLAN=${APP_PLAN:-azure-search-plan}

read -p "Enter unique Web App name: " APP_NAME
while [ -z "$APP_NAME" ]; do
    read -p "Web App name cannot be empty. Please enter a unique name: " APP_NAME
done

read -p "Enter Azure region (or press Enter for 'eastus2'): " LOCATION
LOCATION=${LOCATION:-eastus2}

read -p "Enter App Service SKU (or press Enter for 'B3'): " SKU
SKU=${SKU:-B3}

# Get environment variables
echo -e "\n${YELLOW}Enter your Azure AI Search configuration:${NC}"
read -p "SEARCH_QUERY_KEY: " SEARCH_QUERY_KEY
read -p "SEARCH_ENDPOINT: " SEARCH_ENDPOINT
read -p "SEMANTIC_CONFIGURATION: " SEMANTIC_CONFIGURATION

# Create Resource Group
echo -e "\n${YELLOW}Creating resource group...${NC}"
az group create --name "$RESOURCE_GROUP" --location "$LOCATION"

# Create App Service Plan
echo -e "\n${YELLOW}Creating App Service Plan...${NC}"
az appservice plan create --name "$APP_PLAN" --resource-group "$RESOURCE_GROUP" --sku "$SKU" --is-linux

# Create Web App
echo -e "\n${YELLOW}Creating Web App...${NC}"
az webapp create --resource-group "$RESOURCE_GROUP" --plan "$APP_PLAN" --name "$APP_NAME" --runtime "NODE:20-lts"

# Configure environment variables
echo -e "\n${YELLOW}Configuring environment variables...${NC}"
az webapp config appsettings set --resource-group "$RESOURCE_GROUP" --name "$APP_NAME" --settings \
  SEARCH_QUERY_KEY="$SEARCH_QUERY_KEY" \
  SEARCH_ENDPOINT="$SEARCH_ENDPOINT" \
  SEMANTIC_CONFIGURATION="$SEMANTIC_CONFIGURATION"

# Enable HTTPS only
echo -e "\n${YELLOW}Enabling HTTPS only...${NC}"
az webapp update --resource-group "$RESOURCE_GROUP" --name "$APP_NAME" --https-only true

# Deploy the application
echo -e "\n${YELLOW}Choose deployment method:${NC}"
echo "1) Local Git"
echo "2) ZIP deployment"
echo "3) Skip deployment (I'll deploy manually later)"
read -p "Enter choice (1-3): " DEPLOY_METHOD

case $DEPLOY_METHOD in
  1)
    echo -e "\n${YELLOW}Setting up local git deployment...${NC}"
    DEPLOY_URL=$(az webapp deployment source config-local-git --name "$APP_NAME" --resource-group "$RESOURCE_GROUP" --query url --output tsv)
    
    # Initialize git if needed
    if [ ! -d .git ]; then
      git init
      git add .
      git commit -m "Initial commit"
    fi
    
    # Add Azure remote
    git remote add azure "$DEPLOY_URL" 2>/dev/null || git remote set-url azure "$DEPLOY_URL"
    
    echo -e "\n${GREEN}Setup complete!${NC}"
    echo -e "${YELLOW}To deploy, run:${NC}"
    echo -e "  git push azure main"
    ;;
  2)
    echo -e "\n${YELLOW}Creating deployment package...${NC}"
    zip -r deploy.zip . -x "*.git*" "node_modules/*" ".env" "deploy.zip"
    
    echo -e "\n${YELLOW}Deploying application...${NC}"
    az webapp deployment source config-zip --resource-group "$RESOURCE_GROUP" --name "$APP_NAME" --src deploy.zip
    
    rm deploy.zip
    echo -e "\n${GREEN}Deployment complete!${NC}"
    ;;
  3)
    echo -e "\n${YELLOW}Skipping deployment. You can deploy later using:${NC}"
    echo -e "  az webapp deployment source config-local-git --name $APP_NAME --resource-group $RESOURCE_GROUP"
    ;;
esac

# Display app URL
APP_URL="https://${APP_NAME}.azurewebsites.net"
echo -e "\n${GREEN}═══════════════════════════════════════════════${NC}"
echo -e "${GREEN}Deployment setup complete!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════${NC}"
echo -e "\nYour app URL: ${YELLOW}$APP_URL${NC}"
echo -e "\nTo browse your app, run:"
echo -e "  ${YELLOW}az webapp browse --name $APP_NAME --resource-group $RESOURCE_GROUP${NC}"
echo -e "\nTo view logs, run:"
echo -e "  ${YELLOW}az webapp log tail --name $APP_NAME --resource-group $RESOURCE_GROUP${NC}"
echo -e "\n${GREEN}Happy coding!${NC}\n"
