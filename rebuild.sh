#!/bin/bash
set -e

echo "🛑 プロセス停止..."
lsof -ti:5060 | xargs -r kill -9 || true
pkill -f "python3 no_cache_server.py" || true

echo "🧹 キャッシュ削除..."
rm -rf build .dart_tool
flutter clean > /dev/null

echo "🏗️ ビルド開始..."
flutter build web --release

echo "✅ ビルド検証..."
if [ -f "build/web/main.dart.js" ]; then
    echo "📄 生成ファイル確認:"
    ls -l --time-style=+%T build/web/main.dart.js
else
    echo "❌ ビルド失敗: ファイルが生成されていません"
    exit 1
fi

echo "🚀 サーバー起動..."
python3 no_cache_server.py > /dev/null 2>&1 &
echo "完了."
