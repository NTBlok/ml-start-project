#!/bin/zsh

# Check if project name is provided
if [ $# -eq 0 ]; then
    echo "Error: No project name provided"
    echo "Usage: $0 <project_name>"
    exit 1
fi

export PROJECT_NAME=${1}
echo "Project name: ${PROJECT_NAME}"

# Create project directory structure
set -e  # Exit on error
mkdir -p "${PROJECT_NAME}/backend/utils"
mkdir -p "${PROJECT_NAME}/frontend/src/components"
mkdir -p "${PROJECT_NAME}/frontend/src/pages"
mkdir -p "${PROJECT_NAME}/frontend/src/api"
mkdir -p "${PROJECT_NAME}/frontend/public"

echo "Setting up Python virtual environment..."
python3 -m venv "${PROJECT_NAME}/backend/venv" || {
    echo "ERROR: Failed to create virtual environment"
    exit 1
}

# Create README.md
{
echo "## Backend"
echo
echo "Activate environment"
echo
echo '```bash'
echo "cd \"${PROJECT_NAME}/backend\""
echo 'source "venv/bin/activate"'
echo '```'
echo
echo "Deactivate environment"
echo
echo '```bash'
echo "cd \"${PROJECT_NAME}/backend\""
echo 'deactivate'
echo '```'
echo
echo "## Frontend"
echo
echo "Install dependencies"
echo
echo '```bash'
echo "cd \"${PROJECT_NAME}/frontend\""
echo 'npm install'
echo '```'
echo
echo "Run frontend"
echo
echo '```bash'
echo "cd \"${PROJECT_NAME}/frontend\""
echo 'npm start'
echo '```'
echo
} > "${PROJECT_NAME}/README.md"


# Create requirements.txt for the backend before installing
cat > "${PROJECT_NAME}/backend/requirements.txt" << 'REQUIREMENTS'
fastapi==0.116.1
uvicorn==0.35.0
pandas==2.3.1
scikit-learn==1.7.1
joblib==1.5.1
requests==2.32.4
python-dotenv==1.1.1
langchain==0.3.27
typing==3.7.4.3
REQUIREMENTS

# Copy template files
cp "start_project/templates/data_fetch.py" "${PROJECT_NAME}/backend/"
cp "start_project/templates/data_clean.py" "${PROJECT_NAME}/backend/"
cp "start_project/templates/model_train.py" "${PROJECT_NAME}/backend/"
cp "start_project/templates/model_infer.py" "${PROJECT_NAME}/backend/"
cp "start_project/templates/api.py" "${PROJECT_NAME}/backend/"
cp "start_project/templates/llm.py" "${PROJECT_NAME}/backend/"
cp "start_project/templates/mlApi.js" "${PROJECT_NAME}/frontend/src/api/"
cp "start_project/templates/PredictionForm.js" "${PROJECT_NAME}/frontend/src/components/"


# Create package.json for the frontend
cat > "${PROJECT_NAME}/frontend/package.json" << 'PKG_JSON'
{
  "name": "frontend",
  "version": "0.1.0",
  "private": true,
  "dependencies": {
    "axios": "^1.6.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-scripts": "5.0.1"
  },
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test",
    "eject": "react-scripts eject"
  },
  "eslintConfig": {
    "extends": [
      "react-app"
    ]
  },
  "browserslist": {
    "production": [
      ">0.2%",
      "not dead",
      "not op_mini all"
    ],
    "development": [
      "last 1 chrome version",
      "last 1 firefox version",
      "last 1 safari version"
    ]
  }
}
PKG_JSON

# Activate the backendvirtual environment and install requirements
cd "${PROJECT_NAME}/backend"
source "venv/bin/activate"
pip install --upgrade pip
pip install -r requirements.txt

echo "Project '${PROJECT_NAME}' created successfully!"
