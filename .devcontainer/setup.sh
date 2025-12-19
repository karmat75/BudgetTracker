#!/bin/bash

echo "Setting up ServerOrder development environment..."

# Configure Git inside container
echo "Configuring Git..."
git config --global core.filemode false
git config --global core.autocrlf input

# Fix line endings for shell scripts
echo "Fixing line endings for shell scripts..."
find /workspace -name "*.sh" -type f -exec dos2unix {} \; 2>/dev/null || \
find /workspace -name "*.sh" -type f -exec sed -i 's/\r$//' {} \;

# Fix workspace ownership (DevContainer may mount as root)
echo "Fixing workspace permissions..."
sudo chown -R vscode:vscode /workspace

# Install Python dependencies for backend
if [ -f "/workspace/app/backend/requirements.txt" ]; then
    echo "Installing Python dependencies..."
    pip install -r /workspace/app/backend/requirements.txt
fi

# Install Node.js dependencies for frontend
if [ -f "/workspace/app/frontend/package.json" ]; then
    echo "Installing Frontend dependencies..."
    cd /workspace/frontend
    npm install
fi

# Create .env file from example if it doesn't exist or is invalid
if [ -f "/workspace/app/backend/.env.example" ]; then
    # Check if .env exists and has a valid SECRET_KEY
    ENV_EXISTS=false
    VALID_SECRET=false

    if [ -f "/workspace/app/backend/.env" ]; then
        ENV_EXISTS=true
        # Check if SECRET_KEY exists and is not the default value
        if grep -q "^SECRET_KEY=" /workspace/app/backend/.env; then
            SECRET_VALUE=$(grep "^SECRET_KEY=" /workspace/app/backend/.env | cut -d'=' -f2)
            if [ -n "$SECRET_VALUE" ] && [ "$SECRET_VALUE" != "your-secret-key-change-this-in-production" ]; then
                VALID_SECRET=true
            fi
        fi
    fi

    # Create or regenerate .env if needed
    if [ "$ENV_EXISTS" = false ] || [ "$VALID_SECRET" = false ]; then
        echo "Creating/updating .env file from .env.example..."
        cp /workspace/app/backend/.env.example /workspace/app/backend/.env

        # Generate a secure SECRET_KEY
        echo "Generating secure SECRET_KEY..."
        SECRET_KEY=$(python3 -c "import secrets; print(secrets.token_urlsafe(32))" 2>/dev/null || python -c "import secrets; print(secrets.token_urlsafe(32))")

        if [ -n "$SECRET_KEY" ]; then
            # Use sed to replace the SECRET_KEY line
            sed -i "s|^SECRET_KEY=.*|SECRET_KEY=$SECRET_KEY|" /workspace/app/backend/.env
            echo "✅ .env file created with secure SECRET_KEY"
        else
            echo "⚠️  WARNING: Could not generate SECRET_KEY! Please set it manually in backend/.env"
        fi
    else
        echo "✅ .env file already exists with valid SECRET_KEY"
    fi
fi

# Initialize database only if .env exists with valid SECRET_KEY
if [ -f "/workspace/app/backend/.env" ] && [ -f "/workspace/app/backend/init_db.py" ]; then
    # Verify SECRET_KEY is set before initializing database
    if grep -q "^SECRET_KEY=.\+" /workspace/app/backend/.env && ! grep -q "^SECRET_KEY=your-secret-key-change-this-in-production" /workspace/backend/.env; then
        echo "Initializing database..."
        cd /workspace/backend
        python3 init_db.py 2>/dev/null || python init_db.py
    else
        echo "⚠️  Skipping database initialization (invalid or missing SECRET_KEY in .env)"
        echo "    Please check backend/.env and set a valid SECRET_KEY"
    fi
else
    echo "⚠️  Skipping database initialization (missing .env or init_db.py)"
fi

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Review backend/.env configuration"
echo "  2. Use ./start.sh to start the application"
echo ""
