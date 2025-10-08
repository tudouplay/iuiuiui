#!/bin/bash

# MoonTV 腾讯 EdgeOne 部署脚本

set -e

echo "🚀 开始部署 MoonTV 到腾讯 EdgeOne..."

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_message() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查环境
check_environment() {
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter 未安装"
        exit 1
    fi
    
    print_message "Flutter 版本: $(flutter --version | head -1)"
}

# 构建项目
build_project() {
    print_message "开始构建 Flutter Web 项目..."
    
    flutter clean
    flutter pub get
    
    flutter build web \
        --release \
        --web-renderer html \
        --base-href / \
        --dart-define=FLUTTER_WEB_CANVASKIT_URL=/
    
    print_message "项目构建完成"
}

# 准备 EdgeOne 部署文件
prepare_edgeone_files() {
    print_message "准备 EdgeOne 部署文件..."
    
    # 创建部署目录
    rm -rf deploy-edgeone
    mkdir -p deploy-edgeone
    
    # 复制构建文件
    cp -r build/web/* deploy-edgeone/
    
    # 复制配置文件
    cp edgeone-config.json deploy-edgeone/
    
    # 创建 SPA 重定向文件
    cat > deploy-edgeone/_redirects << EOF
/*    /index.html   200
EOF

    # 创建边缘函数配置
    cat > deploy-edgeone/edge-function.js << EOF
// EdgeOne 边缘函数 - SPA 路由支持
async function handleRequest(request) {
    const url = new URL(request.url);
    const pathname = url.pathname;
    
    // 静态资源直接返回
    if (pathname.startsWith('/assets/') || 
        pathname.endsWith('.js') || 
        pathname.endsWith('.css') ||
        pathname.endsWith('.ico') ||
        pathname.endsWith('.png') ||
        pathname.endsWith('.jpg') ||
        pathname.endsWith('.svg')) {
        return fetch(request);
    }
    
    // 其他所有路由返回 index.html
    return fetch(new Request(new URL('/index.html', request.url), {
        method: request.method,
        headers: request.headers
    }));
}

addEventListener('fetch', event => {
    event.respondWith(handleRequest(event.request));
});
EOF

    print_message "EdgeOne 部署文件准备完成"
}

# 显示部署说明
show_deployment_instructions() {
    print_message ""
    print_message "🎯 EdgeOne 部署说明:"
    print_message "1. 登录腾讯云 EdgeOne 控制台: https://console.cloud.tencent.com/edgeone"
    print_message "2. 选择或创建站点"
    print_message "3. 进入 '站点加速' -> '静态加速'"
    print_message "4. 上传 'deploy-edgeone' 目录中的所有文件"
    print_message "5. 配置以下设置:"
    print_message "   - 默认文档: index.html"
    print_message "   - 错误页面重定向: 启用"
    print_message "   - 404 错误页面: /index.html"
    print_message "6. 保存并部署"
    print_message ""
    print_message "📁 部署文件位置: $(pwd)/deploy-edgeone/"
    print_message ""
    print_message "🌐 访问地址: https://您的域名.edgeone.tencent.com"
}

main() {
    print_message "开始 MoonTV EdgeOne 部署流程..."
    
    check_environment
    build_project
    prepare_edgeone_files
    show_deployment_instructions
    
    print_message "🎉 部署准备完成！请按照上述说明在 EdgeOne 控制台完成部署"
}

main "$@"