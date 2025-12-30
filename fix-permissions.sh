#!/bin/bash
# Fix file ownership after DevContainer usage
# Run this on the host machine if you encounter permission issues

echo "Fixing file ownership in ServerOrder project..."

# Get the current user
CURRENT_USER=$(whoami)
CURRENT_GROUP=$(id -gn)

# Fix ownership
sudo chown -R "$CURRENT_USER:$CURRENT_GROUP" .

# Fix permissions for scripts
chmod +x start.sh stop.sh fix-permissions.sh
chmod +x backend/reset_password.py 2>/dev/null || true

echo "✅ Permissions fixed!"
echo "   Owner: $CURRENT_USER:$CURRENT_GROUP"
