#!/bin/bash

# ═══════════════════════════════════════════════════════════════════════════
# Holy Bible App — Automated Repository Setup
# 
# Usage:
#   1. Copy entire content of this file
#   2. Paste into terminal (or save as setup.sh and run: bash setup.sh)
#   3. Follow the prompts
#   4. All files will be created automatically
#
# ═══════════════════════════════════════════════════════════════════════════

set -e  # Exit on error

echo "═══════════════════════════════════════════════════════════════"
echo "  🎵 Holy Bible App — GitHub Repository Setup"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check prerequisites
echo -e "${BLUE}Checking prerequisites...${NC}"

if ! command -v git &> /dev/null; then
    echo -e "${RED}❌ Git not installed. Please install Git first.${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Git${NC}"

if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js not installed. Please install Node.js first.${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Node.js ($(node --version))${NC}"

if ! command -v npm &> /dev/null; then
    echo -e "${RED}❌ npm not installed. Please install npm first.${NC}"
    exit 1
fi
echo -e "${GREEN}✓ npm ($(npm --version))${NC}"

echo ""
echo -e "${YELLOW}📋 Configuration:${NC}"
echo ""

# Get GitHub username
read -p "GitHub username: " GITHUB_USERNAME
read -p "Repository name (default: Bible-verses-app): " REPO_NAME
REPO_NAME=${REPO_NAME:-Bible-verses-app}

REPO_URL="https://github.com/${GITHUB_USERNAME}/${REPO_NAME}.git"

echo ""
echo -e "${BLUE}Creating repository structure...${NC}"
echo ""

# Create directory
if [ -d "$REPO_NAME" ]; then
    read -p "Folder already exists. Continue? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    mkdir -p "$REPO_NAME"
fi

cd "$REPO_NAME"

# Initialize Git
echo -e "${YELLOW}→ Initializing Git repository...${NC}"
git init
git config user.email "you@example.com" 2>/dev/null || true
git config user.name "Your Name" 2>/dev/null || true

# Create folder structure
echo -e "${YELLOW}→ Creating folder structure...${NC}"
mkdir -p .github/workflows
mkdir -p public/data
mkdir -p public/js
mkdir -p public/css
mkdir -p public/audio/{hymns,keerthanai,keerthanai2,praise1,praise2,praise3,new,chorus,christmas}
mkdir -p android-icons/{mipmap-mdpi,mipmap-hdpi,mipmap-xhdpi,mipmap-xxhdpi,mipmap-xxxhdpi}
mkdir -p scripts

echo -e "${GREEN}✓ Folders created${NC}"

# Create build.yml
echo -e "${YELLOW}→ Creating .github/workflows/build.yml...${NC}"
cat > .github/workflows/build.yml << 'GITHUB_ACTIONS_EOF'
name: Build & Deploy Holy Bible APK

on:
  push:
    branches:
      - main
      - master
      - develop
  pull_request:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout Repository
        uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
          cache: 'npm'
      
      - name: Setup Java
        uses: actions/setup-java@v3
        with:
          distribution: 'temurin'
          java-version: '17'
      
      - name: Setup Android SDK
        uses: android-actions/setup-android@v2
        with:
          api-levels: '30,31,32,33,34'
          build-tools: '34.0.0'
      
      - name: Install Dependencies
        run: npm ci
      
      - name: Add Android Platform
        run: npx cap add android --web-dir=public
        continue-on-error: true
      
      - name: Sync Capacitor
        run: npx cap sync android
      
      - name: Copy App Icons
        run: |
          mkdir -p android/app/src/main/res/mipmap-{mdpi,hdpi,xhdpi,xxhdpi,xxxhdpi}
          cp -r android-icons/mipmap-*/* android/app/src/main/res/ 2>/dev/null || true
          echo "✓ Icons copied"
      
      - name: Build Debug APK
        run: |
          cd android
          ./gradlew clean assembleDebug --stacktrace -x lint
      
      - name: Upload Debug APK
        uses: actions/upload-artifact@v3
        with:
          name: HolyBible-APK-Debug
          path: android/app/build/outputs/apk/debug/app-debug.apk
          retention-days: 30
      
      - name: Build Success
        run: |
          echo ""
          echo "✅ BUILD SUCCESSFUL!"
          echo "📥 Download APK from: Actions → Artifacts → HolyBible-APK-Debug"
GITHUB_ACTIONS_EOF
echo -e "${GREEN}✓ build.yml created${NC}"

# Create capacitor.config.json
echo -e "${YELLOW}→ Creating capacitor.config.json...${NC}"
cat > capacitor.config.json << 'CAPACITOR_EOF'
{
  "appId": "com.vedavachanam.holybible",
  "appName": "வேத வசனம் Bible",
  "webDir": "public",
  "bundledWebRuntime": false,
  "android": {
    "minWebViewVersion": 60,
    "backgroundColor": "#080810",
    "allowMixedContent": true
  },
  "plugins": {
    "LocalNotifications": {
      "smallIcon": "ic_notification",
      "iconColor": "#1a6fd4"
    },
    "AdMob": {
      "appId": "ca-app-pub-9057426786910647~7730878522"
    }
  },
  "server": {
    "androidScheme": "https"
  }
}
CAPACITOR_EOF
echo -e "${GREEN}✓ capacitor.config.json created${NC}"

# Create package.json
echo -e "${YELLOW}→ Creating package.json...${NC}"
cat > package.json << 'PACKAGE_EOF'
{
  "name": "holy-bible-app",
  "version": "6.5.0",
  "description": "வேத வசனம் - Holy Bible: Tamil & English Bible with Christian Songs",
  "main": "index.js",
  "scripts": {
    "android": "npx cap open android",
    "sync": "npx cap sync",
    "build:android": "cd android && ./gradlew assembleDebug"
  },
  "author": "King (masskingslin)",
  "license": "MIT",
  "dependencies": {
    "@capacitor/app": "^6.0.0",
    "@capacitor/core": "^6.0.0",
    "@capacitor/android": "^6.0.0",
    "@capacitor/ios": "^6.0.0",
    "@capacitor/local-notifications": "^6.0.0",
    "@capacitor/share": "^6.0.0",
    "@capacitor-community/admob": "^6.0.0",
    "@capacitor-community/text-to-speech": "^4.0.0"
  }
}
PACKAGE_EOF
echo -e "${GREEN}✓ package.json created${NC}"

# Create .gitignore
echo -e "${YELLOW}→ Creating .gitignore...${NC}"
cat > .gitignore << 'GITIGNORE_EOF'
# Capacitor plugins
plugins/
www/

# Dependencies
node_modules/
package-lock.json
yarn.lock

# Android
android/
.gradle/
build/
*.keystore
.env

# IDE
.vscode/
.idea/
*.swp
*.swo
*~
.DS_Store

# Logs
npm-debug.log*
yarn-debug.log*
yarn-error.log*
GITIGNORE_EOF
echo -e "${GREEN}✓ .gitignore created${NC}"

# Create README.md
echo -e "${YELLOW}→ Creating README.md...${NC}"
cat > README.md << 'README_EOF'
# வேத வசனம் Holy Bible App

Tamil & English Bible with 55+ Christian Songs

## Features

- 📖 31,102 Tamil + English verses
- 🎵 55+ Tamil Christian songs with audio (9 categories)
- 👥 11 Bible character stories with timelines
- 👧 15 Kids' Bible stories
- 🌙 Dark/Light theme toggle
- 🔖 Bookmarks (save up to 200 verses)
- 📱 Offline mode (all data bundled)
- 📢 Google AdMob integration
- 🔊 Text-to-Speech (Tamil & English)
- 📲 Responsive design (all Android sizes)

## Quick Start

```bash
# Install dependencies
npm install

# Sync with Android
npx cap sync android

# Build APK
cd android && ./gradlew assembleDebug

# Install on device
adb install -r android/app/build/outputs/apk/debug/app-debug.apk
```

## Download APK

Built APKs are automatically generated and available at:
- **GitHub Actions** → Click "Actions" tab → Select latest workflow run → "Artifacts" → Download "HolyBible-APK-Debug"

## Project Structure

```
public/
├── index.html              # Main app
├── data/                   # Bible verses (6 files, 31,102 verses)
├── js/                     # JavaScript modules
├── css/                    # Styling
└── audio/                  # 90 MP3 files (9 categories × 10 songs)
```

## Configuration

Edit `capacitor.config.json` to change:
- App ID: `com.vedavachanam.holybible`
- App Name: `வேத வசனம் Bible`
- AdMob App ID: `ca-app-pub-9057426786910647~7730878522`

## License

MIT

## Author

King (masskingslin)

## Support

For issues and questions: https://github.com/${GITHUB_USERNAME}/${REPO_NAME}/issues
README_EOF
echo -e "${GREEN}✓ README.md created${NC}"

# Create manifest.json
echo -e "${YELLOW}→ Creating public/manifest.json...${NC}"
cat > public/manifest.json << 'MANIFEST_EOF'
{
  "name": "வேத வசனம் Holy Bible",
  "short_name": "Holy Bible",
  "description": "Tamil & English Bible with Christian Songs",
  "start_url": "/index.html",
  "display": "standalone",
  "background_color": "#080810",
  "theme_color": "#1a6fd4",
  "orientation": "portrait-primary",
  "icons": [
    {
      "src": "icon-192.png",
      "sizes": "192x192",
      "type": "image/png"
    }
  ]
}
MANIFEST_EOF
echo -e "${GREEN}✓ public/manifest.json created${NC}"

# Create placeholder HTML
echo -e "${YELLOW}→ Creating public/index.html (placeholder)...${NC}"
cat > public/index.html << 'HTML_EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="வேத வசனம் Holy Bible - Tamil & English Bible with Christian Songs">
    <meta name="theme-color" content="#1a6fd4">
    <link rel="manifest" href="manifest.json">
    <link rel="stylesheet" href="css/songs-fixes.css">
    <title>வேத வசனம் Holy Bible</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Noto Sans Tamil", sans-serif;
            background: #080810;
            color: white;
            line-height: 1.6;
        }
        #app {
            min-height: 100vh;
            padding: 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
        }
        h1 { font-size: 2.5em; margin: 20px 0; color: #1a6fd4; }
        p { font-size: 1.1em; margin: 10px 0; }
        .setup-notice {
            background: #1a6fd4;
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
            max-width: 600px;
        }
    </style>
</head>
<body>
    <div id="app">
        <h1>வேத வசனம்</h1>
        <h2>Holy Bible App</h2>
        <div class="setup-notice">
            <p>📚 Placeholder: Replace this with your actual index.html</p>
            <p>Copy your complete index.html file to public/index.html</p>
            <p>Make sure it includes all required script tags for:</p>
            <ul style="text-align: left; margin: 10px 0;">
                <li>data/bd_*.js (Bible verses)</li>
                <li>js/songs-data.js (Song metadata)</li>
                <li>js/songs.js (Song player UI)</li>
                <li>js/fixes.js (Features like bookmarks)</li>
                <li>css/songs-fixes.css (Styling)</li>
            </ul>
        </div>
    </div>
    <script>
        console.log("Ready to load app files. Waiting for:");
        console.log("✓ data/bd_*.js files");
        console.log("✓ js/songs-data.js");
        console.log("✓ js/songs.js");
        console.log("✓ js/fixes.js");
    </script>
</body>
</html>
HTML_EOF
echo -e "${GREEN}✓ public/index.html created (placeholder)${NC}"

# Install npm dependencies
echo ""
echo -e "${BLUE}Installing npm dependencies...${NC}"
echo "(This may take a minute)"
npm install --silent || npm install

echo -e "${GREEN}✓ npm dependencies installed${NC}"

# Add remote and commit
echo ""
echo -e "${BLUE}Setting up Git...${NC}"

git add .
git commit -m "Initial commit: Holy Bible App v6.5 with CI/CD pipeline" 2>/dev/null || echo "Nothing to commit"

# Show next steps
echo ""
echo "═══════════════════════════════════════════════════════════════"
echo -e "${GREEN}✅ SETUP COMPLETE!${NC}"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo -e "${YELLOW}📋 Next Steps:${NC}"
echo ""
echo "1. Copy your files to the project:"
echo "   • public/index.html (your main app file)"
echo "   • public/data/bd_*.js (Bible verses)"
echo "   • public/js/songs-data.js, songs.js, fixes.js"
echo "   • public/css/songs-fixes.css"
echo "   • public/audio/ (90 MP3 files)"
echo "   • android-icons/ (app icons in 5 densities)"
echo ""
echo "2. Create a GitHub repository:"
echo "   https://github.com/new"
echo "   → Name: $REPO_NAME"
echo "   → Do NOT initialize with README/gitignore"
echo "   → Create"
echo ""
echo "3. Connect to GitHub:"
echo "   git remote add origin $REPO_URL"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""
echo "4. Monitor the build:"
echo "   https://github.com/$GITHUB_USERNAME/$REPO_NAME/actions"
echo ""
echo "5. Download APK:"
echo "   Click the workflow run → Artifacts → HolyBible-APK-Debug"
echo ""
echo "6. Install on device:"
echo "   adb install -r app-debug.apk"
echo ""
echo -e "${BLUE}Project folder: $(pwd)${NC}"
echo ""
