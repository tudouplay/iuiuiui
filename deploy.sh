#!/bin/bash

# MoonTV 部署脚本

set -e

echo "🚀 开始部署 MoonTV..."

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 函数：打印彩色消息
print_message() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查 Flutter 环境
check_flutter() {
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter 未安装，请先安装 Flutter"
        exit 1
    fi
    
    print_message "Flutter 版本: $(flutter --version | head -1)"
}

# 构建项目
build_project() {
    print_message "开始构建项目..."
    
    # 清理
    flutter clean
    
    # 获取依赖
    flutter pub get
    
    # 构建 Web 版本
    flutter build web \
        --release \
        --web-renderer html \
        --base-href / \
        --dart-define=FLUTTER_WEB_CANVASKIT_URL=/
    
    print_message "项目构建完成"
}

# 部署到 Netlify
deploy_netlify() {
    if ! command -v netlify &> /dev/null; then
        print_warning "Netlify CLI 未安装，跳过 Netlify 部署"
        return
    fi
    
    print_message "开始部署到 Netlify..."
    netlify deploy --prod --dir=build/web
    print_message "Netlify 部署完成"
}

# 部署到 Vercel
deploy_vercel() {
    if ! command -v vercel &> /dev/null; then
        print_warning "Vercel CLI 未安装，跳过 Vercel 部署"
        return
    fi
    
    print_message "开始部署到 Vercel..."
    cd build/web
    vercel --prod
    cd ../..
    print_message "Vercel 部署完成"
}

# 主函数
main() {
    print_message "MoonTV 部署流程开始"
    
    # 检查环境
    check_flutter
    
    # 构建项目
    build_project
    
    # 选择部署平台
    echo "请选择部署平台:"
    echo "1) Netlify"
    echo "2) Vercel" 
    echo "3) 腾讯 EdgeOne"
    echo "4) 全部部署"
    read -p "请输入选择 (1-4): " choice
    
    case $choice in
        1)
            deploy_netlify
            ;;
        2)
            deploy_vercel
            ;;
        3)
            print_message "腾讯 EdgeOne 部署请手动上传 build/web 目录内容"
            ;;
        4)
            deploy_netlify
            deploy_vercel
            print_message "腾讯 EdgeOne 部署请手动上传 build/web 目录内容"
            ;;
        *)
            print_error "无效选择"
            exit 1
            ;;
    esac
    
    print_message "🎉 部署流程完成！"
}

# 执行主函数
main "$@"