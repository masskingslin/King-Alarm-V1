[app]

# (str) App title
title = Crown Bible App

# (str) Package name
package.name = crownbible

# (str) Package domain
package.domain = org.king

# (str) Source code location
source.dir = .

# (list) File extensions to include
source.include_exts = py,kv,png,jpg,jpeg,json,ttf,otf,txt,db,sqlite3

# (list) Source patterns to include
source.include_patterns = assets/*,assets/**/*

# (str) App version
version = 1.0.0

# ── REQUIREMENTS ──────────────────────────────────────────────────────────────
# FIXED: removed invalid 'python3', added hostpython3, pinned kivy==2.3.0
requirements = hostpython3,kivy==2.3.0,pyjnius,android

# ── ANDROID ───────────────────────────────────────────────────────────────────
android.api = 33
android.minapi = 21

# FIXED: full NDK version string (25b is wrong)
android.ndk = 25.1.8937393

# FIXED: explicit ABI targets
android.archs = arm64-v8a,armeabi-v7a

# FIXED: auto-accept SDK licenses
android.accept_sdk_license = True

# FIXED: required for AdMob
android.enable_androidx = True

# ── ASSETS ────────────────────────────────────────────────────────────────────
# FIXED: src:dest format
android.add_assets = assets/bible:assets/bible

# ── PERMISSIONS ───────────────────────────────────────────────────────────────
android.permissions = INTERNET,ACCESS_NETWORK_STATE,RECEIVE_BOOT_COMPLETED

# ── GRADLE / ADMOB ────────────────────────────────────────────────────────────
android.gradle_dependencies = com.google.android.gms:play-services-ads:22.6.0

# FIXED: Google Maven repo for AdMob
android.add_gradle_repositories = google()

# ── DISPLAY ───────────────────────────────────────────────────────────────────
orientation = portrait
fullscreen = 0

# ── P4A ───────────────────────────────────────────────────────────────────────
# FIXED: stable branch (master is broken)
p4a.branch = stable

# ── BUILD ─────────────────────────────────────────────────────────────────────
log_level = 2

[buildozer]
warn_on_root = 1