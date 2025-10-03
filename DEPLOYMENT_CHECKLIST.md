# Azure Deployment Checklist

## Pre-Deployment
- [ ] I have an Azure account (create at https://azure.microsoft.com/free/)
- [ ] I have my Azure AI Search credentials ready:
  - [ ] SEARCH_QUERY_KEY
  - [ ] SEARCH_ENDPOINT
  - [ ] SEMANTIC_CONFIGURATION

## Deployment Steps (Choose ONE method)

### Using Automated Script ⚡
- [ ] Install Azure CLI (https://aka.ms/azure-cli)
- [ ] Run: `./deploy-to-azure.sh`
- [ ] Follow the prompts
- [ ] Visit your app URL

### Using Azure Portal 🌐
- [ ] Go to https://portal.azure.com
- [ ] Create a new Web App
- [ ] Configure it (Node 18 LTS, Linux)
- [ ] Add environment variables in Configuration
- [ ] Deploy code (Local Git, GitHub, or ZIP)
- [ ] Browse to your app

### Using VS Code 💻
- [ ] Install Azure App Service extension
- [ ] Sign in to Azure
- [ ] Create new Web App
- [ ] Deploy to Web App
- [ ] Configure environment variables

### Using GitHub Actions 🔄
- [ ] Create Web App in Azure Portal
- [ ] Download publish profile
- [ ] Add as GitHub secret: AZURE_WEBAPP_PUBLISH_PROFILE
- [ ] Update .github/workflows/azure-deploy.yml with your app name
- [ ] Push to GitHub
- [ ] Monitor deployment in Actions tab

## Post-Deployment
- [ ] Visit https://YOUR-APP-NAME.azurewebsites.net
- [ ] Test the search functionality
- [ ] Check application logs if needed
- [ ] Enable HTTPS only
- [ ] Set up monitoring (optional)
- [ ] Configure custom domain (optional)

## Troubleshooting
If something doesn't work:
- [ ] Check environment variables are set correctly
- [ ] View application logs: `az webapp log tail --name YOUR-APP --resource-group YOUR-RG`
- [ ] Restart the app: `az webapp restart --name YOUR-APP --resource-group YOUR-RG`
- [ ] Verify deployment succeeded in Azure Portal → Deployment Center

## Cost Management
- [ ] Choose appropriate pricing tier (F1 for testing, B1 for small apps)
- [ ] Remember to stop or delete resources when not in use
- [ ] Monitor costs in Azure Portal → Cost Management

## Security
- [ ] Environment variables are set (not hardcoded)
- [ ] .env file is NOT committed to git (already in .gitignore ✓)
- [ ] HTTPS only is enabled
- [ ] API keys are kept secure

---

Need help? See:
- **Quick Guide**: DEPLOY_QUICKSTART.md
- **Detailed Guide**: DEPLOYMENT.md
