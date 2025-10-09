#!/bin/bash

echo "🚀 EdgeOne 专用构建脚本"
echo "参考: https://github.com/tudouplay/edgeone-moontv"

# 设置错误处理
set -e

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✅ $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️ $1${NC}"; }

# 检查环境
check_environment() {
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter 未安装"
        exit 1
    fi
    print_success "Flutter 版本: $(flutter --version | head -1)"
}

# 清理和准备
prepare_build() {
    print_success "准备构建环境..."
    
    # 清理缓存
    flutter clean
    
    # 删除可能冲突的文件
    rm -rf build/
    rm -rf .dart_tool/
    
    # 获取依赖
    flutter pub get
}

# EdgeOne 优化构建
build_for_edgeone() {
    print_success "开始 EdgeOne 优化构建..."
    
    flutter build web \
        --release \
        --web-renderer html \
        --base-href / \
        --pwa-strategy none \
        --no-tree-shake-icons \
        --dart-define=FLUTTER_WEB_CANVASKIT_URL=/ \
        --dart-define=EDGEONE_DEPLOY=true \
        --dart-define=TMDb_API_KEY=3f3a99a9456828a1a834f9e89c1b0236 \
        --dart-define=TMDb_ACCESS_TOKEN=eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIzZjNhOTlhOTQ1NjgyOGExYTgzNGY5ZTg5YzFiMDIzNiIsIm5iZiI6MTc1OTkzMjUzOS4wNDQsInN1YiI6IjY4ZTY3MDdiYmJlNWEyNDgxMzc5NTIwOCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.NFZ1dVPIV3mlsjRsvzcTZtsKBgXuEewgsmHxrFu8Fgk
    
    print_success "构建完成"
}

# 创建 EdgeOne 部署包
create_edgeone_package() {
    print_success "创建 EdgeOne 部署包..."
    
    # 清理旧包
    rm -rf edgeone-package
    mkdir -p edgeone-package
    
    # 复制构建文件
    cp -r build/web/* edgeone-package/
    
    # 添加 EdgeOne 特定文件
    cat > edgeone-package/edgeone-rules.json << 'EOF'
{
  "version": "1.0",
  "rules": [
    {
      "type": "file",
      "match": "/assets/*",
      "cache": {
        "ttl": 31536000,
        "status": "public"
      }
    },
    {
      "type": "file", 
      "match": "/*.js",
      "cache": {
        "ttl": 31536000,
        "status": "public"
      }
    },
    {
      "type": "spa",
      "match": "/*",
      "rewrite": "/index.html"
    }
  ]
}
EOF

    # 创建部署说明
    cat > edgeone-package/README-EdgeOne.md << 'EOF'
# MoonTV EdgeOne 部署说明

## 部署步骤：
1. 登录腾讯云 EdgeOne 控制台
2. 进入「站点加速」->「静态加速」
3. 删除所有现有文件
4. 上传本目录所有文件到根目录
5. 配置设置：
   - 默认文档：index.html
   - 错误页面重定向：启用
   - 404/403/500 错误重定向到：/index.html

## 重要配置：
- ✅ SPA 路由支持（必需）
- ✅ 错误页面重定向（必需） 
- ✅ 静态资源缓存（推荐）

## 验证部署：
访问您的域名，应该显示 MoonTV 应用
如果出现白屏，检查浏览器控制台错误信息
EOF

    print_success "部署包创建完成: edgeone-package/"
}

# 验证构建结果
verify_build() {
    print_success "验证构建结果..."
    
    local errors=0
    
    # 检查关键文件
    essential_files=(
        "edgeone-package/index.html"
        "edgeone-package/main.dart.js" 
        "edgeone-package/flutter.js"
        "edgeone-package/assets/AssetManifest.json"
    )
    
    for file in "${essential_files[@]}"; do
        if [ -f "$file" ]; then
            print_success "找到: $file"
        else
            print_error "缺失: $file"
            errors=$((errors+1))
        fi
    done
    
    # 检查文件大小
    if [ -f "edgeone-package/main.dart.js" ]; then
        local size=$(du -h "edgeone-package/main.dart.js" | cut -f1)
        print_success "main.dart.js 大小: $size"
        
        # 检查是否过大
        local size_bytes=$(du -b "edgeone-package/main.dart.js" | cut -f1)
        if [ $size_bytes -gt 5000000 ]; then
            print_warning "main.dart.js 文件较大，考虑优化"
        fi
    fi
    
    if [ $errors -eq 0 ]; then
        print_success "✅ 所有验证通过"
    else
        print_error "❌ 发现 $errors 个问题，请检查构建过程"
        exit 1
    fi
}

# 显示部署信息
show_deployment_info() {
    echo ""
    echo "🎉 EdgeOne 部署准备完成！"
    echo ""
    echo "📁 部署文件位置: $(pwd)/edgeone-package/"
    echo ""
    echo "🚀 下一步操作:"
    echo "1. 登录腾讯云 EdgeOne 控制台: https://console.cloud.tencent.com/edgeone"
    echo "2. 选择您的站点"
    echo "3. 进入「站点加速」->「静态加速」"
    echo "4. 📝 删除所有现有文件"
    echo "5. 📤 上传 edgeone-package/ 目录中的所有文件"
    echo "6. ⚙️  配置:"
    echo "   - 默认文档: index.html"
    echo "   - 错误页面重定向: 启用"
    echo "   - 404/403/500 错误重定向到: /index.html"
    echo "7. 💾 保存并等待部署完成"
    echo ""
    echo "🌐 测试访问: https://您的域名"
    echo ""
    echo "📋 上传文件列表:"
    ls -la edgeone-package/ | head -10
    echo ""
    print_success "参考仓库: https://github.com/tudouplay/edgeone-moontv"
}

main() {
    echo "🚀 开始 EdgeOne 部署流程..."
    echo "📚 参考: tudouplay/edgeone-moontv"
    
    check_environment
    prepare_build
    build_for_edgeone
    create_edgeone_package
    verify_build
    show_deployment_info
}

main "$@"