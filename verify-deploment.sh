#!/bin/bash

echo "🌐 验证 EdgeOne 部署..."

# 替换为您的实际域名
DOMAIN="您的域名.edgeone.tencent.com"

echo "测试访问: https://$DOMAIN/"

# 测试主页
curl -s -o /dev/null -w "主页状态: %{http_code}\n" "https://$DOMAIN/"

# 测试静态资源
curl -s -o /dev/null -w "JS文件状态: %{http_code}\n" "https://$DOMAIN/main.dart.js"

# 测试不存在的路径（应该返回 200 因为 SPA 重定向）
curl -s -o /dev/null -w "SPA路由状态: %{http_code}\n" "https://$DOMAIN/any-route"

echo "✅ 验证完成"