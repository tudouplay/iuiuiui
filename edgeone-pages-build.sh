#!/bin/bash
# edgeone-pages-build.sh - 专为 EdgeOne Pages 优化

echo "🚀 EdgeOne Pages 构建开始..."

# 检查环境
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter 未安装，无法自动构建"
    echo "💡 请先在本地构建，然后上传 build/web 目录"
    exit 1
fi

echo "✅ 检测到 Flutter 环境"

# 清理和准备
echo "🧹 清理项目..."
flutter clean

# 获取依赖
echo "📦 获取依赖..."
flutter pub get

# 构建 Web 版本
echo "🔨 构建 Web 应用..."
flutter build web \
  --release \
  --web-renderer html \
  --base-href / \
  --pwa-strategy none \
  --dart-define=FLUTTER_WEB_CANVASKIT_URL=/ \
  --dart-define=EDGEONE_PAGES_DEPLOY=true

# 验证构建
if [ -f "build/web/index.html" ] && [ -f "build/web/main.dart.js" ]; then
    echo "✅ 构建成功"
    echo "📁 输出目录: build/web"
    echo "📊 文件大小:"
    echo "   - main.dart.js: $(du -h build/web/main.dart.js | cut -f1)"
    echo "   - 总文件数: $(find build/web -type f | wc -l)"
else
    echo "❌ 构建失败"
    exit 1
fi