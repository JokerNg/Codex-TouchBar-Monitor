# Codex Touch Bar Monitor

English | [简体中文](readme.ch.md)

![Codex Touch Bar Monitor running on a physical MacBook Pro Touch Bar](docs/images/touch-bar-preview.png)

CodexTouchBarMonitor is a native macOS utility that keeps OpenAI Codex quota and token usage visible on a physical MacBook Pro Touch Bar. The menu bar is used only for controls and does not display quota values.

Maintainer: [JokerNg](https://github.com/JokerNg)

## Features

- Keeps the menu bar icon compact and uses it only for controls.
- Runs without a Dock icon.
- Continuously shows the 5-hour and weekly limits, remaining percentages, and reset times on the Touch Bar. Pro accounts without a 5-hour limit show only the weekly limit.
- Shows official Codex token usage, including yesterday's usage and the account lifetime total.
- Refreshes every 60 seconds and preserves the last valid data when a refresh fails.
- Refreshes immediately when the Codex icon is tapped. The refresh badge spins, then briefly shows a cyan checkmark on success or a red exclamation mark on failure or timeout.
- Reconnects automatically when the app-server connection fails or exits, while showing connection status and the last update time.
- Highlights reset cards in red during the three days before their earliest expiration.
- Switches the right-side area between reset cards, a 26-week token heatmap, and today's estimated cost.
- Uses a dark zero level and five fixed heatmap levels: 1–25M, 25–50M, 50–75M, 75–100M, and over 100M tokens.
- Skips unavailable pages. It can remember the last page, pin a page, or rotate automatically every 10 seconds.
- Calculates today's and yesterday's local token usage and estimated API cost, including cached-input percentage. Local data refreshes every minute, on manual refresh, after wake, and across date changes.
- Uses a dedicated Pro layout with aligned weekly quota, reset time, yesterday usage, and lifetime usage.
- Supports System, Chinese, and English UI languages with immediate persistent switching.
- Starts and exits automatically with ChatGPT or Codex.
- Can hide either the Touch Bar display or the menu bar icon.

## Data Sources

Quota and official token usage come from the local Codex app-server. The app does not scrape web pages or require an API key:

```text
account/rateLimits/read
account/usage/read
```

Local cost statistics recursively scan JSONL files under `~/.codex/sessions/` and aggregate them by local date and model. Prices come from the [public LiteLLM price table](https://github.com/BerriAI/litellm/blob/main/model_prices_and_context_window.json), refreshed daily and cached at `~/Library/Caches/CodexTouchBarMonitor/litellm-prices.json`.

Dollar values are estimates based on current API prices, not Codex subscription charges. `codex-auto-review` is priced as `gpt-5.6-luna`; models without a matching price are shown as unknown. Today's cost is compared with the complete previous day, and cache hit rate is cached input tokens divided by all input tokens.

The app automatically looks for Codex at:

```text
/Applications/ChatGPT.app/Contents/Resources/codex
/Applications/Codex.app/Contents/Resources/codex
/Applications/GPT.app/Contents/Resources/codex
```

## Credits

This project is based on Jack Chen's open-source [TouchBarCodexToken](https://github.com/jackchensky/TouchBarCodexToken) and retains the original MIT copyright notice.

## Compatibility

- macOS 11 Big Sur or later.
- Current Homebrew and DMG releases target Apple Silicon (`arm64`).
- ChatGPT, Codex, or GPT must be installed with a working local Codex app-server.
- A Mac with a physical Touch Bar is required for the Touch Bar display.

## Touch Bar

The app presents a persistent system-modal Touch Bar that remains visible when switching windows.

It includes:

- Codex icon.
- Continuous bars for the 5-hour and weekly limits.
- Remaining percentages and reset times.
- Yesterday's token usage and account lifetime token usage.
- Reset cards, a 26-week token heatmap, and today's estimated cost and tokens in a switchable right-side area.

Tap the Codex icon to refresh immediately. The badge spins during refresh and briefly shows the result afterward. Dots in the lower-right corner indicate available pages. The cost page shows today's estimated cost and tokens; per-model estimates, previous-day comparison, and cached-input percentage are available from the menu.

Persistent display uses an undocumented macOS AppKit system-modal Touch Bar API. It is not suitable for the Mac App Store and may be affected by future macOS changes.

## Menu Bar

The menu bar icon provides controls to:

- Show or hide the Touch Bar.
- Refresh data immediately.
- Reload the Touch Bar.
- Enable or disable launching with Codex.
- Enable automatic updates or manually check, download, and install an update.
- View connection status and the last update time.
- Select System, Chinese, or English language.
- Remember, automatically rotate, or pin the default Touch Bar page.
- View today's local usage, previous-day cost comparison, cached-input percentage, and per-model estimated cost.
- Hide the menu bar icon; reopen the app to restore it.
- Quit the app.

## Build and Run

Build the app:

```bash
scripts/build-app.sh
open build/CodexTouchBarMonitor.app
```

The app is generated at `build/CodexTouchBarMonitor.app`. After the first manual launch, it installs a user LaunchAgent by default and follows ChatGPT or Codex startup and exit. This behavior can be disabled from the menu.

Build a DMG:

```bash
scripts/package-dmg.sh
```

The output filename follows the version in `Info.plist`. Builds use ad-hoc signing, so macOS may warn that the developer cannot be verified. If needed, right-click the app in Finder and choose Open.

Run directly during development:

```bash
swift run
```

## Homebrew

Install from the Tap:

```bash
brew install --cask jokerng/tap/codex-touchbar-monitor
```

Upgrade:

```bash
brew upgrade --cask jokerng/tap/codex-touchbar-monitor
```

## Regenerate the App Icon

Generate the ICNS file from `Resources/AppIcon.png`:

```bash
scripts/make-app-icon.py
```

## Privacy

CodexTouchBarMonitor does not store passwords, API keys, authorization codes, or account credentials. Quota data comes from the local Codex app-server, and session logs are parsed locally. Network requests are limited to downloading the public price table and fetching update information and packages from GitHub. Session content and usage data are not uploaded.

## License

This project is available under the [MIT License](LICENSE).
