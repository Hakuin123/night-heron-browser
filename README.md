# 夜鹭浏览器 🦅

Chromium 整活套皮项目。

## 仓库结构

```
.
├── .github/
│   └── workflows/
│       └── build.yml          # GitHub Actions 构建工作流（手动触发）
├── patches/
│   └── yelu-branding-strings.patch  # 品牌字符串替换 patch
└── branding/                  # ← 你需要自己放进来的图标文件
    ├── chrome.ico             # 主程序图标（必须包含 16/32/48/256px）
    ├── logo_16.png
    ├── logo_24.png
    ├── logo_32.png
    ├── logo_48.png
    ├── logo_64.png
    ├── logo_128.png
    └── logo_256.png
```

## 使用方法

### 第一步：准备图标

把你的夜鹭图准备成以下格式，放入 `branding/` 目录：

- `.ico` 文件：用 ImageMagick 生成
  ```bash
  magick input.png -define icon:auto-resize=256,64,48,32,16 chrome.ico
  ```
- 各尺寸 `.png`：直接 resize 即可
  ```bash
  for size in 16 24 32 48 64 128 256; do
    magick input.png -resize ${size}x${size} logo_${size}.png
  done
  ```

### 第二步：检查 patch

`patches/yelu-branding-strings.patch` 里的行号是基于当前 Chromium 版本生成的模板，
如果 apply 失败，需要手动核对 `chrome/app/chromium_strings.grd` 里的实际行号并调整。

### 第三步：触发构建

1. 把本仓库 push 到你的 GitHub
2. 进入 Actions → "Build 夜鹭浏览器" → Run workflow
3. 等待约 3~6 小时
4. 构建成功后在 Artifacts 下载安装包

## 常见问题

**patch apply 失败**  
上游 chromium_strings.grd 的内容随 Chromium 版本变化。
解决方法：下载对应版本的源码，找到实际字符串位置，手动修改 patch 的 context lines。

**Actions 超时**  
workflow 已设置 `timeout-minutes: 360`，免费账号单次最多 6 小时。
如果还是超时，考虑使用 self-hosted runner。

**图标没变**  
确认 `branding/` 目录里的文件已经 commit 并 push。
Actions 里的工作目录是 checkout 下来的仓库，本地文件不会自动同步。
