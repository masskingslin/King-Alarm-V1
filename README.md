# ✝ Crown Bible App — வேத வசனம்

**Tamil + English Bible · 31,102 Verses · Audio TTS · AI Search · Character Stories**

---

## Features

| Feature | Details |
|---|---|
| 📖 **31,102 Verses** | Tamil (IRV) + English (WEB), fully offline |
| 🔊 **Audio TTS** | Verse, chapter, and character story reading in Tamil & English |
| ✦ **AI Search** | Offline keyword + topic search, 26 topic chips |
| 👤 **Character Stories** | 11 Bible characters with timeline, verses, lessons |
| 📅 **Daily Verse** | Changes every day, Tamil + English |
| ✦ **Verse of the Week** | Famous highlighted verse, rotates weekly |
| 📖 **Chapter Reader** | All 66 books, all chapters, TA/EN/Both toggle |
| ☀ **Theme Toggle** | Dark / Light mode, saved between sessions |
| ♥ **Save Verses** | Bookmark any verse, highlighted in gold |
| ⎘ **Copy Verse** | Copy Tamil + English + reference to clipboard |

---

## Repository Structure

```
Bible-verses-app/
├── .github/
│   └── workflows/
│       └── build.yml          ← GitHub Actions → APK
├── public/                    ← webDir (Capacitor)
│   ├── index.html             ← ENTIRE APP (HTML + CSS + JS)
│   ├── manifest.json
│   ├── data/
│   │   ├── bd_a.js            ← Genesis → Numbers
│   │   ├── bd_b.js            ← Deuteronomy → 2 Samuel
│   │   ├── bd_c.js            ← 1 Kings → Psalms
│   │   ├── bd_d.js            ← Proverbs → Ezekiel
│   │   ├── bd_e.js            ← Daniel → Mark
│   │   └── bd_f.js            ← Luke → Revelation
│   └── characters.js          ← 11 Bible character stories
├── capacitor.config.json
├── package.json
└── README.md
```

---

## Build APK via GitHub Actions

1. Push any change to `main` branch
2. Go to **Actions** tab → latest run
3. Wait ~5 minutes for build to complete
4. Download **CrownBible-APK-{number}** from Artifacts
5. Install on Android phone

---

## Bible Data Sources

- **English**: World English Bible (WEB) — Public Domain
- **Tamil**: Indian Revised Version (IRV) — திருத்தப்பட்ட வேதாகமம்
- **Characters**: Custom data — 11 key Bible figures

---

## Technology

- **Frontend**: Pure HTML + CSS + JavaScript (no React, no build step)
- **Platform**: Capacitor 5 → Android WebView
- **Build**: GitHub Actions → Gradle → APK
- **Audio**: Web Speech API (built into Android)
- **Storage**: localStorage (offline, no server)

---

## Architecture

```
┌─────────────────────────────────┐
│     PRESENTATION LAYER          │  HTML + CSS (index.html)
│  Home · Verses · Search ·       │
│  Books · Characters · Saved     │
├─────────────────────────────────┤
│     LOGIC LAYER                 │  Pure JavaScript modules
│  BD · ST · AU · R · RM         │  (no framework)
│  CR · CD · SV · SA · SB        │
├─────────────────────────────────┤
│     DATA LAYER                  │  bd_a.js → bd_f.js
│  31,102 verses in RAM           │  characters.js
│  localStorage for user data     │  localStorage
├─────────────────────────────────┤
│     PLATFORM LAYER              │  Capacitor + Android
│  WebView · Speech API           │  minAPI 21 (Android 5+)
│  Clipboard · localStorage       │  targetAPI 33
└─────────────────────────────────┘
```

---

## Google AdSense Setup

Four ad slots are pre-placed in `index.html`:
1. Home screen — below tiles
2. AI Search — above results
3. Characters — top of page
4. Saved — bottom of page

Replace `<span class="adlbl">GOOGLE ADSENSE — SLOT N</span>` with your real AdSense `<ins>` tags.

For APK → use **Google AdMob** via Capacitor plugin instead.
