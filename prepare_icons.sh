#!/usr/bin/env bash
# prepare_icons.sh
# 用法: bash prepare_icons.sh <你的夜鹭图片路径>
# 依赖: ImageMagick (magick / convert)
#
# 生成结果放在 ./branding/ 目录下，直接 commit 进仓库即可

set -e

INPUT="$1"

if [ -z "$INPUT" ]; then
  echo "用法: bash prepare_icons.sh <图片路径>"
  echo "示例: bash prepare_icons.sh ~/夜鹭.png"
  exit 1
fi

if ! command -v magick &>/dev/null && ! command -v convert &>/dev/null; then
  echo "❌ 未检测到 ImageMagick，请先安装："
  echo "   Windows: https://imagemagick.org/script/download.php#windows"
  echo "   macOS:   brew install imagemagick"
  echo "   Linux:   sudo apt install imagemagick"
  exit 1
fi

# 优先用新版 magick，回退到 convert
CMD="magick"
command -v magick &>/dev/null || CMD="convert"

mkdir -p branding

echo "📐 生成各尺寸 PNG..."
for size in 16 24 32 48 64 128 256; do
  $CMD "$INPUT" -resize ${size}x${size} "branding/logo_${size}.png"
  echo "   ✅ logo_${size}.png"
done

echo "🪟 生成 Windows .ico（含多尺寸）..."
$CMD "$INPUT" \
  -define icon:auto-resize=256,64,48,32,16 \
  "branding/chrome.ico"
echo "   ✅ chrome.ico"

echo ""
echo "🎉 完成！图标已生成到 branding/ 目录"
echo "   下一步：git add branding/ && git commit -m 'add yelu branding icons'"
