# Codex Touch Bar Monitor

[English](README.md) | 简体中文

![Codex Touch Bar Monitor 在实体 MacBook Pro Touch Bar 上运行](docs/images/touch-bar-preview.png)

CodexTouchBarMonitor 是一款原生 macOS 工具，把 OpenAI Codex 的额度和 Token 用量直接放到实体 MacBook Pro Touch Bar 上。你无需反复打开用量页面，就能随时查看剩余额度；菜单栏只负责控制，不显示额度数值。

作者：[JokerNg](https://github.com/JokerNg)

## 功能

- 菜单栏只保留一个紧凑的控制图标。
- 启动后不在 Dock 中显示图标。
- Touch Bar 常驻显示 5 小时额度、周额度、剩余百分比和重置时间；没有 5 小时限制的 Pro 账户只显示周额度。
- 显示 Codex 官方 Token 用量，包括昨日用量和账户累计用量。
- 每 60 秒刷新一次；刷新失败时保留上次有效结果。
- 点按 Codex 图标可立即刷新；刷新时徽标会旋转，成功后短暂显示青色勾，失败或超时则显示红色感叹号。
- app-server 连接断开或进程退出后自动重连，并显示连接状态和最后更新时间。
- 距离最早到期的重置卡不足 3 天时，将其标为红色。
- 点按右侧区域，可在重置卡、26 周 Token 用量热力图和今日费用估算之间切换。
- 热力图的零值使用深灰色，其余按五档显示：1–2500 万、2500–5000 万、5000–7500 万、7500 万–1 亿和 1 亿以上 Token。
- 自动跳过不可用页面；可以记住上次页面、固定某个页面，或每 10 秒自动轮播。
- 统计今天和昨天的本地 Token 用量及 API 费用估算，并显示缓存输入占比；每分钟、手动刷新、唤醒和跨日时更新本地数据。
- Pro 账户使用专属布局，对齐显示周额度、重置时间、昨日用量和累计用量。
- 支持跟随系统、简体中文和 English 界面，切换后立即生效并持久保存。
- 随 ChatGPT 或 Codex 自动启动和退出。
- 可分别隐藏 Touch Bar 显示和菜单栏图标。

## 数据来源

额度和官方 Token 用量来自本地 Codex app-server。应用不抓取网页，也不需要填写 API Key：

```text
account/rateLimits/read
account/usage/read
```

本地费用统计会递归扫描 `~/.codex/sessions/` 下的 JSONL 文件，并按本地日期和模型汇总。价格来自 [LiteLLM 公开价格表](https://github.com/BerriAI/litellm/blob/main/model_prices_and_context_window.json)，每天更新，并缓存到 `~/Library/Caches/CodexTouchBarMonitor/litellm-prices.json`。

美元金额仅是按当前 API 价格计算的估算值，不代表 Codex 订阅账单。`codex-auto-review` 按 `gpt-5.6-luna` 计价；没有匹配价格的模型显示为未知。今日费用会与完整的昨日数据比较；缓存命中率 = 缓存输入 Token ÷ 全部输入 Token。

应用会自动查找以下 Codex 可执行文件：

```text
/Applications/ChatGPT.app/Contents/Resources/codex
/Applications/Codex.app/Contents/Resources/codex
/Applications/GPT.app/Contents/Resources/codex
```

## 来源与致谢

本项目在 Jack Chen 的开源项目 [TouchBarCodexToken](https://github.com/jackchensky/TouchBarCodexToken) 基础上开发，并保留原项目的 MIT 版权声明。

## 兼容性

- macOS 11 Big Sur 或更新版本。
- 当前 Homebrew 和 DMG 安装包面向 Apple Silicon（`arm64`）。
- 需要安装 ChatGPT、Codex 或 GPT，并确保本地 Codex app-server 可用。
- 使用 Touch Bar 功能需要配备实体 Touch Bar 的 Mac。

## Touch Bar

应用通过系统模态接口让 Touch Bar 常驻显示，切换窗口后也不会消失。

Touch Bar 包括：

- Codex 图标。
- 5 小时额度和周额度连续进度条。
- 剩余百分比和重置时间。
- 昨日 Token 用量和账户累计 Token 用量。
- 可在右侧区域切换的重置卡、26 周 Token 用量热力图，以及今日费用估算和 Token 用量。

点按 Codex 图标可立即刷新。刷新期间徽标会旋转，完成后短暂显示结果。右下角的圆点表示当前可用页面。费用页显示今日费用估算和 Token 用量；逐模型估算、昨日费用对比和缓存输入占比可从菜单查看。

Touch Bar 常驻显示使用 macOS 未公开的 AppKit 系统模态接口，不适合提交 Mac App Store，未来 macOS 更新也可能影响其行为。

## 菜单栏

点击菜单栏图标可以：

- 显示或隐藏 Touch Bar。
- 立即刷新数据。
- 重新加载 Touch Bar。
- 开启或关闭“随 Codex 启动”。
- 开启自动更新，或手动检查更新并选择下载、安装。
- 查看连接状态和最后更新时间。
- 选择跟随系统、简体中文或 English 界面。
- 将默认 Touch Bar 页面设为记住上次、自动轮播或固定页面。
- 查看今日用量、昨日费用对比、缓存输入占比和逐模型费用估算。
- 隐藏菜单栏图标；重新打开 App 即可恢复显示。
- 退出应用。

## 构建和运行

构建 App：

```bash
scripts/build-app.sh
open build/CodexTouchBarMonitor.app
```

构建完成后会生成 `build/CodexTouchBarMonitor.app`。首次手动打开后，应用默认安装用户级 LaunchAgent，之后会随 ChatGPT 或 Codex 自动启动和退出；也可以从菜单关闭自动启动。

构建 DMG：

```bash
scripts/package-dmg.sh
```

输出文件名跟随 `Info.plist` 中的版本号。当前构建使用 ad-hoc 签名，macOS 首次打开时可能提示无法验证开发者；如遇到此提示，请在 Finder 中右键 App 并选择“打开”。

开发期间直接运行：

```bash
swift run
```

## Homebrew

从 Tap 安装：

```bash
brew install --cask jokerng/tap/codex-touchbar-monitor
```

升级：

```bash
brew upgrade --cask jokerng/tap/codex-touchbar-monitor
```

## 重新生成应用图标

根据 `Resources/AppIcon.png` 生成 ICNS 文件：

```bash
scripts/make-app-icon.py
```

## 隐私

CodexTouchBarMonitor 不保存密码、API Key、授权码或账户凭据。额度数据来自本地 Codex app-server，会话日志也只在本机解析。网络请求仅用于下载公开价格表，以及从 GitHub 获取更新信息和安装包；应用不会上传会话内容或用量数据。

## 许可证

本项目采用 [MIT License](LICENSE)。
