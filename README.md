# EasyWalletTheme

Custom theming tweak for Easy Wallet (`tw.com.easycard.easycardwallet`), built with Theos + GitHub Actions (sideload IPA via cyan). Scaffolded from YTMusicUltimate's workflow.

## Status: v0.1 scaffold (generic UIKit hooks, no class-dump yet)

- Accent color: `UIButton.tint`, `UISwitch.onTint`, `UIProgressView`, nav/tab tint
- NavBar / TabBar background: `UINavigationBarAppearance` / `UITabBarAppearance`
- Custom image: `Documents/EWTheme/bg.png` painted behind full-screen VCs (tag 7741)
- All gated by `EasyWalletTheme/enabled`, colors as `#RRGGBB` hex

Prefs schema (`NSUserDefaults` key `EasyWalletTheme`):

```json
{ "enabled": true, "accentHex": "#22c55e", "navBarHex": "#111827", "tabBarHex": "#111827" }
```

## Web editor

Open `tools/theme-editor/index.html` in a browser: pick colors, preview, load a
background PNG, export the defaults snippet. No rebuild needed to re-theme.

## Build (GitHub Actions)

Base IPA (verified 2026-10-09, 85,377,379 bytes, `PK` zip, `Accept-Ranges: bytes`):

```text
https://file.wayhost.cc.cd/815c78vl/
```

This is your decrypted Easy Wallet 3.1.36. No server needed — pass it as
`ipa_url` at dispatch, or save it as the `BASE_IPA_URL` repo secret.

1. `gh repo create EasyWalletTheme --private --source=. --push`
2. No-secret build (recommended now that your server is down):

   ```powershell
   gh workflow run "Build and Release EasyWalletTheme" --ref main `
     -f ipa_url=https://file.wayhost.cc.cd/815c78vl/
   ```

   Or set-and-forget: `gh secret set BASE_IPA_URL -b"https://file.wayhost.cc.cd/815c78vl/"`
   then every `git push` to `main` builds.
3. Release `build-N` contains `EasyWalletTheme.ipa`.

Local check (Windows, no Theos): open `tools/theme-editor/index.html`.
Real compile happens on `macos-latest` CI with theos `344ee59` + `iPhoneOS16.5.sdk`.

## Next (needs device)

- Class-dump 3.1.36 to name the real header/card/tab classes; replace generic
  `UINavigationBar`/`UITabBar` hooks with app-specific ones if they ignore appearance.
- Settings page inside the app (like YTM's ThemeSettingsController) instead of defaults-edit.
- Bundle a default `bg.png` in `layout/` if you want one shipped in the .deb.
