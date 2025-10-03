# Azure Deployment Guide

This guide will help you deploy your Azure AI Search application to Azure App Service.

## Prerequisites

- Azure account with an active subscription
- Azure CLI installed (or use Azure Cloud Shell)
- Git initialized in your project

## Deployment Options

### Option 1: Deploy using Azure CLI (Recommended)

#### Step 1: Login to Azure
```bash
az login
```

#### Step 2: Create a Resource Group (if you don't have one)
```bash
az group create --name myResourceGroup --location eastus
```

#### Step 3: Create an App Service Plan
```bash
az appservice plan create --name myAppServicePlan --resource-group myResourceGroup --sku B1 --is-linux
```

#### Step 4: Create a Web App
```bash
az webapp create --resource-group myResourceGroup --plan myAppServicePlan --name <your-unique-app-name> --runtime "NODE:18-lts"
```
**Note:** Replace `<your-unique-app-name>` with a globally unique name (e.g., `azure-search-app-yourname`)

#### Step 5: Configure Environment Variables
```bash
az webapp config appsettings set --resource-group myResourceGroup --name <your-unique-app-name> --settings \
  SEARCH_QUERY_KEY="your_actual_search_key" \
  SEARCH_ENDPOINT="https://your-service.search.windows.net/indexes/your-index/docs/search?api-version=2024-11-01-preview" \
  SEMANTIC_CONFIGURATION="your-semantic-config-name"
```

#### Step 6: Deploy the Application

**Option A: Deploy from Local Git**
```bash
# Configure deployment user (one-time setup)
az webapp deployment user set --user-name <username> --password <password>

# Configure local git deployment
az webapp deployment source config-local-git --name <your-unique-app-name> --resource-group myResourceGroup

# Add Azure remote and push
git remote add azure <deployment-git-url-from-previous-command>
git add .
git commit -m "Deploy to Azure"
git push azure main
```

**Option B: Deploy from GitHub**
```bash
# If your code is in GitHub
az webapp deployment source config --name <your-unique-app-name> --resource-group myResourceGroup --repo-url <your-github-repo-url> --branch main --manual-integration
```

**Option C: Deploy using ZIP**
```bash
# Create a zip file of your application
zip -r app.zip . -x "*.git*" "node_modules/*" ".env"

# Deploy the zip
az webapp deployment source config-zip --resource-group myResourceGroup --name <your-unique-app-name> --src app.zip
```

#### Step 7: Browse your application
```bash
az webapp browse --name <your-unique-app-name> --resource-group myResourceGroup
```

Or visit: `https://<your-unique-app-name>.azurewebsites.net`

---

### Option 2: Deploy using VS Code Azure Extension

1. Install the "Azure App Service" extension in VS Code
2. Click the Azure icon in the sidebar
3. Sign in to Azure
4. Right-click on "App Services" and select "Create New Web App..."
5. Follow the prompts:
   - Enter a unique name
   - Select Node.js runtime
   - Select your subscription and resource group
6. After creation, right-click your app and select "Deploy to Web App..."
7. Configure environment variables in the Azure portal

---

### Option 3: Deploy using Azure Portal

1. Go to [Azure Portal](https://portal.azure.com)
2. Create a new "Web App" resource
3. Configure:
   - **Resource Group**: Create new or use existing
   - **Name**: Choose a unique name
   - **Runtime stack**: Node 18 LTS
   - **Operating System**: Linux
   - **Region**: Choose your region
   - **Pricing Plan**: Select appropriate tier (B1 or higher recommended)
4. Click "Review + Create", then "Create"
5. Once created, go to the resource
6. Navigate to **Configuration** → **Application settings**
7. Add your environment variables:
   - `SEARCH_QUERY_KEY`
   - `SEARCH_ENDPOINT`
   - `SEMANTIC_CONFIGURATION`
8. Navigate to **Deployment Center**
9. Choose your deployment source (GitHub, Local Git, etc.)
10. Follow the prompts to complete deployment

---

## Post-Deployment Configuration

### Enable HTTPS Only (Recommended)
```bash
az webapp update --resource-group myResourceGroup --name <your-unique-app-name> --https-only true
```

### View Application Logs
```bash
# Enable logging
az webapp log config --name <your-unique-app-name> --resource-group myResourceGroup --application-logging filesystem --level information

# Stream logs
az webapp log tail --name <your-unique-app-name> --resource-group myResourceGroup
```

### Scale Your Application
```bash
# Scale up (change pricing tier)
az appservice plan update --name myAppServicePlan --resource-group myResourceGroup --sku P1V2

# Scale out (add instances)
az appservice plan update --name myAppServicePlan --resource-group myResourceGroup --number-of-workers 2
```

---

## Troubleshooting

### Check if the app is running
```bash
az webapp show --name <your-unique-app-name> --resource-group myResourceGroup --query state
```

### Restart the app
```bash
az webapp restart --name <your-unique-app-name> --resource-group myResourceGroup
```

### Check environment variables are set
```bash
az webapp config appsettings list --name <your-unique-app-name> --resource-group myResourceGroup
```

### Common Issues

1. **App not starting**: Check that `package.json` has the correct start script
2. **Environment variables not working**: Verify they're set in App Service Configuration
3. **Port errors**: The app now uses `process.env.PORT` which Azure provides automatically
4. **Build failures**: Check deployment logs in Azure Portal → Deployment Center → Logs

---

## Cost Optimization

- **Free Tier (F1)**: Good for testing, limited compute
- **Basic (B1)**: ~$13/month, suitable for low-traffic apps
- **Standard (S1)**: ~$70/month, includes auto-scaling and staging slots
- **Premium (P1V2)**: Better performance for production workloads

Remember to stop or delete resources when not in use to avoid charges.

---

## Security Best Practices

1. ✅ Never commit `.env` file to Git (already in `.gitignore`)
2. ✅ Use Azure Key Vault for sensitive configuration
3. ✅ Enable HTTPS only
4. ✅ Use managed identities when possible
5. ✅ Regularly update dependencies (`npm audit fix`)
6. ✅ Enable Application Insights for monitoring

---

## Next Steps

- Set up custom domain
- Configure SSL certificate
- Enable Application Insights for monitoring
- Set up CI/CD with GitHub Actions
- Configure staging slots for zero-downtime deployments

For more information, visit: https://docs.microsoft.com/azure/app-service/
