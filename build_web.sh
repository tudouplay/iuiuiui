#!/bin/bash

echo "开始构建 MoonTV Web 版本..."

# 清理构建缓存
flutter clean

# 获取依赖
flutter pub get

# 构建 Web 版本
echo "构建 Flutter Web 版本..."
flutter build web \
    --release \
    --web-renderer html \
    --pwa-strategy none \
    --base-href / \
    --dart-define=FLUTTER_WEB_CANVASKIT_URL=/

echo "构建完成！"
echo "输出目录: build/web"

# 创建部署包
echo "创建部署包..."
cd build/web
tar -czf ../moon_tv_web_$(date +%Y%m%d_%H%M%S).tar.gz .
cd ../..

echo "部署包已创建在 build/ 目录"