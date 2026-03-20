# வேத வசனம் — Bible Verses App v2.0

Tamil & English Bible App · Metro Widget 8 · Offline AI Search · Audio TTS · Google Ads

---

## Architecture

```
ARCHITECTURE V2 (Fixed)
═══════════════════════════════════════════════════════════

  public/index.html          ← Single-file app (HTML+CSS+JS)
  │
  ├── DATA LAYER             ← Structured Bible data (30 verses + 37 books)
  │   └── DATA object        Pure JS, no dependencies, expandable via JSON
  │
  ├── LOGIC LAYER
  │   ├── Search.js          Offline keyword+tag search engine
  │   ├── State.js           Persistent state (localStorage)
  │   └── Audio.js           TTS engine (Web Speech API, fully guarded)
  │
  ├── UI LAYER
  │   ├── UI.js              Verse card renderer
  │   ├── Reading.js         Fullscreen reading mode
  │   ├── Home.js            Metro tile grid + live clock
  │   ├── Verses.js          All verses + filter
  │   ├── AI.js              Search screen
  │   └── Books.js           Books grid (OT/NT filter)
  │
  └── APP CONTROLLER
      └── App.js             Router, init, event delegation

  capacitor.config.json      ← webDir: "public" (no build needed!)
  package.json               ← Only Capacitor (NO React, NO react-scripts)
  .github/workflows/build.yml ← GitHub Actions → APK

═══════════════════════════════════════════════════════════

WHY NOT REACT?
  React + react-scripts adds 3 failure points:
    1. JSX parse errors
    2. npm install failures
    3. react-scripts compile failures

  Pure HTML+JS has ZERO build failures.
  Capacitor wraps ANY HTML file — React is never needed.
```

---

## Features

| Feature | Status |
|---------|--------|
| Tamil + English verses | 30 verses |
| Offline AI search | Tag + keyword scoring engine |
| Audio TTS | Web Speech API (en + ta) |
| Reading mode | Fullscreen, A+ A- font control |
| Dark / Light theme | Persisted in localStorage |
| Saved verses | Persisted in localStorage |
| Live clock tile | Updates every second |
| Daily verse | Rotates by day of week |
| Google Ad slots | 5 placements ready |
| Books grid | 37 books, OT/NT filter |
| Metro Widget 8 UI | Flat tiles, Metro palette |

---

## Expanding to Full Bible (31,102 verses)

Replace the VERSES array in index.html with a fetch:

```javascript
// In DATA object:
fetch('./bible.json')
  .then(function(r){ return r.json(); })
  .then(function(data){
    VERSES = data;
    App.init();
  });
```

Download bible.json from:
- https://github.com/scrollmapper/bible_databases (KJV, MIT license)
- https://github.com/thiagobodruk/bible (Tamil + English, free)

---

## Build APK via GitHub

1. Create GitHub repo
2. Upload all files (keep folder structure)
3. Actions tab → Build Bible APK → Run workflow
4. Download APK from Artifacts
5. Install on Android

---

## Google AdSense Setup

1. Get approved at adsense.google.com
2. In `public/index.html` uncomment:
```html
<script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-XXXXXXXXXXXXXXXX" crossorigin="anonymous"></script>
```
3. Replace `.ad-slot` divs with real `<ins>` tags

For Android APK → use Google AdMob instead:
- npm install @capacitor-community/admob
- Register at admob.google.com
