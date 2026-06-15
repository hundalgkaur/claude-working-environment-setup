# crossplatform-app-starter

an iOS, Android + web app in one: React Native (Expo) mobile + Next.js web sharing an API, with user accounts

## Getting started

```bash
npm install
npm run dev
```

## Platforms

The mobile app is React Native (Expo), so iOS and Android build from the same codebase:

```bash
npm run ios       # iOS simulator      (or press `i` in the Expo dev menu)
npm run android   # Android emulator   (or press `a` in the Expo dev menu)
npm run web       # Next.js web app
```

Android needs Android Studio (SDK + an emulator, or a device with USB debugging on); iOS needs Xcode on macOS.

## Project docs

- `CLAUDE.md` — project context + coding guidelines (loaded by Claude Code each session)
- `docs/CLAUDE_CODE_GUIDE.md` — how to use Claude Code on this repo
- `CHECKLISTS.md` — quality checklists · `CONTRIBUTING.md` — conventions
