#!/bin/bash

# Claude Global Session Manager - Installation Script
# https://github.com/dompl/claude-session-manager

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

INSTALL_DIR="$HOME/.local/bin"
SESSION_DIR="$HOME/.claude-sessions"

echo -e "${BLUE}🚀 Claude Global Session Manager Installation${NC}"
echo "==============================================="
echo ""

# Check requirements
echo -e "${YELLOW}🔍 Checking requirements...${NC}"

# Check Python3
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}❌ Python3 is required but not installed${NC}"
    echo "Please install Python3 and try again"
    exit 1
fi
echo -e "${GREEN}✅ Python3 found${NC}"

# Check if Claude CLI is available (optional check)
if command -v claude &> /dev/null; then
    echo -e "${GREEN}✅ Claude CLI found${NC}"
else
    echo -e "${YELLOW}⚠️  Claude CLI not found (install it from https://docs.anthropic.com/en/docs/claude-code)${NC}"
fi

echo ""

# Create directories
echo -e "${YELLOW}📁 Creating directories...${NC}"

mkdir -p "$INSTALL_DIR"
mkdir -p "$SESSION_DIR/sessions"

echo -e "${GREEN}✅ Created $INSTALL_DIR${NC}"
echo -e "${GREEN}✅ Created $SESSION_DIR${NC}"

# Copy scripts
echo -e "${YELLOW}📄 Installing scripts...${NC}"

# Check if we're in the repo directory
if [ -d "bin" ]; then
    cp bin/claude-save "$INSTALL_DIR/"
    cp bin/claude-resume "$INSTALL_DIR/"
    cp bin/claude-list "$INSTALL_DIR/"
    echo -e "${GREEN}✅ Scripts copied from bin/ directory${NC}"
else
    echo -e "${RED}❌ bin/ directory not found${NC}"
    echo "Please run this script from the claude-session-manager repository root"
    exit 1
fi

# Make executable
chmod +x "$INSTALL_DIR/claude-save"
chmod +x "$INSTALL_DIR/claude-resume" 
chmod +x "$INSTALL_DIR/claude-list"

echo -e "${GREEN}✅ Scripts made executable${NC}"

# Check PATH
echo ""
echo -e "${YELLOW}🛤️  Checking PATH...${NC}"

if [[ ":$PATH:" == *":$INSTALL_DIR:"* ]]; then
    echo -e "${GREEN}✅ $INSTALL_DIR is already in PATH${NC}"
    PATH_OK=true
else
    echo -e "${YELLOW}⚠️  $INSTALL_DIR is not in PATH${NC}"
    PATH_OK=false
fi

# Initialize config files
echo -e "${YELLOW}⚙️  Initializing configuration...${NC}"

# Create config.json if it doesn't exist
if [ ! -f "$SESSION_DIR/config.json" ]; then
    cat > "$SESSION_DIR/config.json" << EOF
{
  "version": "1.0.0",
  "maxRecentSessions": 5,
  "defaultSessionRetention": 30,
  "installDate": "$(date -Iseconds)"
}
EOF
    echo -e "${GREEN}✅ Created config.json${NC}"
fi

# Create recent.json if it doesn't exist  
if [ ! -f "$SESSION_DIR/recent.json" ]; then
    echo '{"sessions": []}' > "$SESSION_DIR/recent.json"
    echo -e "${GREEN}✅ Created recent.json${NC}"
fi

echo ""
echo -e "${GREEN}🎉 Installation completed successfully!${NC}"
echo ""

# Test installation
echo -e "${YELLOW}🧪 Testing installation...${NC}"

if [ "$PATH_OK" = true ]; then
    # Test commands
    if command -v claude-save &> /dev/null; then
        echo -e "${GREEN}✅ claude-save command available${NC}"
    else
        echo -e "${RED}❌ claude-save command not found${NC}"
    fi
    
    if command -v claude-resume &> /dev/null; then
        echo -e "${GREEN}✅ claude-resume command available${NC}"
    else
        echo -e "${RED}❌ claude-resume command not found${NC}"
    fi
    
    if command -v claude-list &> /dev/null; then
        echo -e "${GREEN}✅ claude-list command available${NC}"
    else
        echo -e "${RED}❌ claude-list command not found${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  Commands not yet available in PATH${NC}"
fi

echo ""
echo -e "${BLUE}📋 Next Steps:${NC}"

if [ "$PATH_OK" = false ]; then
    echo -e "${YELLOW}1. Add $INSTALL_DIR to your PATH:${NC}"
    echo ""
    
    # Detect shell and give appropriate instructions
    if [ -n "$ZSH_VERSION" ]; then
        echo "   echo 'export PATH=\"\$PATH:$INSTALL_DIR\"' >> ~/.zshrc"
        echo "   source ~/.zshrc"
    elif [ -n "$BASH_VERSION" ]; then
        echo "   echo 'export PATH=\"\$PATH:$INSTALL_DIR\"' >> ~/.bashrc"
        echo "   source ~/.bashrc"
    else
        echo "   echo 'export PATH=\"\$PATH:$INSTALL_DIR\"' >> ~/.profile"
        echo "   source ~/.profile"
    fi
    echo ""
fi

echo -e "${BLUE}2. Start using the commands:${NC}"
echo ""
echo "   claude-save \"your session description\""
echo "   claude-resume"
echo "   claude-list"
echo ""

echo -e "${BLUE}3. Read the documentation:${NC}"
echo ""
echo "   README.md - Overview and examples"
echo "   docs/usage.md - Detailed usage guide"
echo ""

echo -e "${GREEN}🎯 You're ready to give Claude persistent memory across all your projects!${NC}"
echo ""

# Optional: Add to PATH automatically
if [ "$PATH_OK" = false ]; then
    echo -e "${YELLOW}Would you like to automatically add $INSTALL_DIR to your PATH? (y/n)${NC}"
    read -r response
    
    if [[ "$response" =~ ^[Yy] ]]; then
        # Detect shell config file
        if [ -n "$ZSH_VERSION" ]; then
            CONFIG_FILE="$HOME/.zshrc"
        elif [ -n "$BASH_VERSION" ]; then
            CONFIG_FILE="$HOME/.bashrc"  
        else
            CONFIG_FILE="$HOME/.profile"
        fi
        
        echo "export PATH=\"\$PATH:$INSTALL_DIR\"" >> "$CONFIG_FILE"
        echo -e "${GREEN}✅ Added to $CONFIG_FILE${NC}"
        echo -e "${YELLOW}Please run: source $CONFIG_FILE${NC}"
    fi
fi
