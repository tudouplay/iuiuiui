#!/bin/bash

# EdgeOne 部署检查脚本

set -e

echo "🔍 检查 EdgeOne 部署配置..."

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✅ $1 存在${NC}"
    else
        echo -e "${RED}❌ $1 不存在${NC}"
        return 1
    fi
}

check_directory() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✅ $1 目录存在${NC}"
        echo "   文件列表:"
        find "$1" -type f -name "*" | head -10
    else
        echo -e "${RED}❌ $1 目录不存在${NC}"
        return 1
    fi
}

echo "1. 检查构建文件..."
check_directory "build/web"
check_file "build/web/index.html"
check_file "build/web/main.dart.js"
check_file "build/web/flutter.js"

echo ""
echo "2. 检查部署文件..."
check_directory "deploy-edgeone"
check_file "deploy-edgeone/index.html"
check_file "deploy-edgeone/_redirects"
check_file "deploy-edgeone/edgeone-config.json"

echo ""
echo "3. 检查关键文件大小..."
echo "   main.dart.js: $(du -h build/web/main.dart.js | cut -f1)"
echo "   flutter.js: $(du -h build/web/flutter.js | cut -f1)"

echo ""
echo "4. 检查配置文件内容..."
echo "   _redirects 内容:"
cat deploy-edgeone/_redirects

echo ""
echo "5. 部署建议:"
echo "   📦 上传整个 deploy-edgeone 目录到 EdgeOne"
echo "   ⚙️  确保配置了 SPA 路由重定向"
echo "   🔧 设置错误页面重定向到 index.html"
echo "   🌐 测试访问: https://您的域名/"

echo ""
echo "🎯 如果仍有 404 错误，请检查:"
echo "   - EdgeOne 控制台的路由配置"
echo "   - 默认文档是否设置为 index.html"
echo "   - 错误页面重定向是否启用"