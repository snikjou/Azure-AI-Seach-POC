# Quick Deploy to Azure - Choose Your Method

## 🚀 Method 1: Automated Script (Easiest with Azure CLI)

If you have Azure CLI installed:

```bash
./deploy-to-azure.sh
```

This interactive script will:
- Create all necessary Azure resources
- Configure environment variables
- Deploy your application
- Provide you with the URL

---

## 🌐 Method 2: Azure Portal (No CLI needed)

1. **Go to [Azure Portal](https://portal.azure.com)**

2. **Create Web App:**
   - Click "+ Create a resource"
   - Search for "Web App"
   - Click "Create"

3. **Configure:**
   - **Subscription**: Choose your subscription
   - **Resource Group**: Create new (e.g., "azure-search-rg")
   - **Name**: Choose unique name (e.g., "myazuresearchapp123")
   - **Publish**: Code
   - **Runtime stack**: Node 18 LTS
   - **Operating System**: Linux
   - **Region**: East US (or your preferred region)
   - **Pricing Plan**: Basic B1 (or Free F1 for testing)

4. **Review + Create** → **Create** (wait ~2 minutes)

5. **Configure Environment Variables:**
   - Go to your new Web App resource
   - Click "Configuration" (under Settings)
   - Click "+ New application setting" for each:
     - Name: `SEARCH_QUERY_KEY`, Value: `your-actual-key`
     - Name: `SEARCH_ENDPOINT`, Value: `your-endpoint-url`
     - Name: `SEMANTIC_CONFIGURATION`, Value: `your-config-name`
   - Click "Save"

6. **Deploy Code:**
   - Option A: **Local Git**
     - Go to "Deployment Center"
     - Select "Local Git"
     - Click "Save"
     - Copy the Git URL
     - In your terminal:
       ```bash
       git remote add azure <paste-git-url>
       git push azure main
       ```
   
   - Option B: **GitHub**
     - Go to "Deployment Center"
     - Select "GitHub"
     - Authorize and select your repository
     - Select branch "main"
     - Click "Save"
   
   - Option C: **ZIP Deploy**
     - Create a zip file: `zip -r app.zip . -x "*.git*" "node_modules/*" ".env"`
     - Go to your Web App → "Advanced Tools" → "Go"
     - Click "Tools" → "Zip Push Deploy"
     - Drag and drop your `app.zip`

7. **Browse Your App:**
   - Click "Browse" or visit: `https://your-app-name.azurewebsites.net`

---

## 💻 Method 3: VS Code Extension

1. **Install Extension:**
   - Open VS Code Extensions (Ctrl+Shift+X)
   - Search for "Azure App Service"
   - Install it

2. **Deploy:**
   - Click Azure icon in sidebar
   - Sign in to Azure
   - Right-click "App Services" → "Create New Web App..."
   - Follow prompts (choose name, Node 18, region)
   - Right-click your new app → "Deploy to Web App..."
   - Select this folder

3. **Configure Environment Variables:**
   - Right-click your app → "Open in Portal"
   - Follow step 5 from Method 2

---

## ☁️ Method 4: Azure Cloud Shell (No installation needed)

1. **Open [Azure Cloud Shell](https://shell.azure.com)**

2. **Clone or upload your code:**
   ```bash
   # If your code is on GitHub:
   git clone https://github.com/yourusername/Azure-AI-Seach-POC.git
   cd Azure-AI-Seach-POC
   
   # Or upload files using the upload button in Cloud Shell
   ```

3. **Run deployment commands:**
   ```bash
   # Set variables
   RESOURCE_GROUP="azure-search-rg"
   APP_NAME="myazuresearchapp123"  # Choose unique name
   LOCATION="eastus"
   
   # Create resources
   az group create --name $RESOURCE_GROUP --location $LOCATION
   
   az appservice plan create --name myPlan --resource-group $RESOURCE_GROUP --sku B1 --is-linux
   
   az webapp create --resource-group $RESOURCE_GROUP --plan myPlan --name $APP_NAME --runtime "NODE:18-lts"
   
   # Configure environment variables
   az webapp config appsettings set --resource-group $RESOURCE_GROUP --name $APP_NAME --settings \
     SEARCH_QUERY_KEY="your-key" \
     SEARCH_ENDPOINT="your-endpoint" \
     SEMANTIC_CONFIGURATION="your-config"
   
   # Deploy
   zip -r app.zip . -x "*.git*" "node_modules/*" ".env"
   az webapp deployment source config-zip --resource-group $RESOURCE_GROUP --name $APP_NAME --src app.zip
   
   # Open app
   az webapp browse --name $APP_NAME --resource-group $RESOURCE_GROUP
   ```

---

## 🔄 Method 5: GitHub Actions (CI/CD)

1. **Create Azure Web App** (use Method 2, steps 1-5)

2. **Get Publish Profile:**
   - In Azure Portal, go to your Web App
   - Click "Get publish profile" (top toolbar)
   - This downloads a `.PublishSettings` file

3. **Add to GitHub Secrets:**
   - Go to your GitHub repository
   - Settings → Secrets and variables → Actions
   - Click "New repository secret"
   - Name: `AZURE_WEBAPP_PUBLISH_PROFILE`
   - Value: Paste entire contents of `.PublishSettings` file
   - Click "Add secret"

4. **Update workflow file:**
   - Edit `.github/workflows/azure-deploy.yml`
   - Change `AZURE_WEBAPP_NAME` to your app name

5. **Push to GitHub:**
   ```bash
   git add .
   git commit -m "Add Azure deployment workflow"
   git push
   ```

6. **Watch it Deploy:**
   - Go to "Actions" tab in your GitHub repo
   - Watch the deployment progress
   - Your app will auto-deploy on every push to main!

---

## 🔍 After Deployment

### Check if it's working:
```bash
curl https://your-app-name.azurewebsites.net
```

### View logs:
```bash
az webapp log tail --name your-app-name --resource-group azure-search-rg
```

### Restart app:
```bash
az webapp restart --name your-app-name --resource-group azure-search-rg
```

---

## 💰 Estimated Costs

- **Free (F1)**: $0/month - Good for testing
- **Basic (B1)**: ~$13/month - Good for small apps
- **Standard (S1)**: ~$70/month - Production ready

**Remember to delete resources when not needed to avoid charges!**

---

## ❓ Need Help?

- View detailed guide: `DEPLOYMENT.md`
- Azure App Service docs: https://docs.microsoft.com/azure/app-service/
- Azure support: https://azure.microsoft.com/support/

---

## 🎯 Recommended for You

- **If you have Azure CLI**: Use Method 1 (automated script)
- **If you prefer web interface**: Use Method 2 (Azure Portal)
- **If you use VS Code**: Use Method 3 (VS Code extension)
- **If you have no tools installed**: Use Method 4 (Cloud Shell)
- **If you want CI/CD**: Use Method 5 (GitHub Actions)
