#!/bin/bash

# Usage: ./deploy.sh [user@host]
# Example: ./deploy.sh root@192.168.2.1
# Or: REMOTE=root@192.168.2.1 ./deploy.sh

# Use first argument if provided, otherwise check REMOTE env var
TARGET="${1:-$REMOTE}"

if [ -z "$TARGET" ]; then
    echo "❌ Error: Remote target is required."
    echo "Usage: $0 <user@host>"
    echo "   or: REMOTE=<user@host> $0"
    exit 1
fi

TEMP_DIR="/tmp/deploy_$(date +%s)"

echo "🚀 Deploying to $TARGET..."

# 1. Prepare remote
echo "--> Creating temp dir on remote..."
ssh "$TARGET" "mkdir -p $TEMP_DIR"

# 2. Upload files (scp -r includes .DS_Store, we filter later)
echo "--> Uploading files..."
scp -r -O etc usr "$TARGET:$TEMP_DIR/"
if [ $? -ne 0 ]; then
    echo "❌ Upload failed."
    exit 1
fi

# 3. Swap files on remote
echo "--> Swapping files on remote..."
ssh "$TARGET" "
    set -e
    cd $TEMP_DIR

    # Find all files, excluding .DS_Store, and move them
    find etc usr -type f -not -name '.DS_Store' 2>/dev/null | while read -r file; do
        echo \"   Installing /\$file ...\"
        mkdir -p \"/\$(dirname \"\$file\")\"
        # mv -f avoids 'Text file busy' by replacing the directory entry
        mv -f \"\$file\" \"/\$file\"
    done

    # Cleanup
    cd /
    rm -rf $TEMP_DIR
"

echo "✅ Deployment complete!"
