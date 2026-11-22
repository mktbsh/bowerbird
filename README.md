<img src="icon.png" width="128" height="128" alt="Bowerbird icon">

# Bowerbird

English | [日本語](README.ja.md)

A native, local-first alternative to [Eagle](https://eagle.cool) for macOS: collect images, videos
and other references, then sort them with folders, tags and smart folders and find them again by
text, colour or the words inside a picture. Libraries live on your own Mac, as plain folders or
encrypted.

The name comes from the bowerbird, which gathers things it finds and arranges them by colour
around its bower.

This repository only publishes the app. The source is kept elsewhere.

## What it does

- **Collect**: drag and drop, paste from the clipboard, a browser extension, screenshots, or a
  folder tree from Finder (kept as folders). Web pages are saved as one self-contained file.
  Sidecars from yt-dlp / gallery-dl (`.info.json`), `.xmp` and `.txt` bring titles, notes and tags.
- **Kinds**: images (including animated GIF), video and audio (libmpv), PDF, SVG, 3D models
  (USDZ, OBJ, STL, PLY) and web bookmarks.
- **Organize**: nested folders (an item can be in several), tags, notes and source URLs, smart
  folders, batch rename, undo for every edit. Annotate images with boxes, points and strokes;
  pin notes to moments in a video.
- **Find**: search across titles, tags, folders, notes, annotations, URLs and the text recognized
  in images (Japanese and English); filter by kind, tags, size, length and colour; similar images.
- **Look**: grid and list, a stage that zooms and plays everything, slideshows.
- **Move around**: several libraries side by side, copy or move items between them, export folders
  or packs that carry tags, folders and notes to another Mac. A local HTTP API for scripts.
- **Keep it yours**: libraries stay on this Mac unless you add a copy on Google Drive. Encrypted
  libraries come with a 24-word recovery phrase.

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/mktbsh/bowerbird/main/install.sh | sh
```

[`install.sh`](install.sh) downloads the latest release, checks that it is signed with the
Bowerbird release certificate, puts `Bowerbird.app` in `/Applications` and opens it. Read it
first if you like; set `BOWERBIRD_INSTALL_DIR=~/Applications` to install elsewhere. Running it
again installs a newer release if there is one.

Downloaded with curl, the app is not marked as coming from the internet, so Gatekeeper lets it
open even though it is signed with its own certificate rather than an Apple Developer ID.

<details>
<summary>Installing the zip by hand</summary>

1. Download the latest `Bowerbird-<version>.zip` from [Releases](../../releases) and unzip it.
2. Move `Bowerbird.app` to `/Applications`.
3. A browser marks the download, so Gatekeeper stops the first launch. Either clear the mark once:

   ```sh
   xattr -dr com.apple.quarantine /Applications/Bowerbird.app
   ```

   or try to open the app, then choose Open Anyway in System Settings ▸ Privacy & Security.

</details>

After that the app checks this repository's releases and updates itself (Settings ▸ About ▸
Updates). It only installs builds signed with the same certificate.

Versions are release dates: `YYYY.M.D`, with `.N` for a later release the same day.

Requires macOS 14 or later on Apple silicon.

## Privacy, security & signing

- **No Apple Developer ID / notarization (yet)**: releases are signed with Bowerbird's own release
  certificate (`SHA-1: A8CE2558390C191B685C7B926A1DCFFF9FF0C727`). Both [`install.sh`](install.sh)
  and the built-in updater verify the bundle identifier (`app.bowerbird.macos`) and this exact
  certificate before installing or updating, and reject anything else. Because Bowerbird was built
  for personal use and already works well for my own needs, I have not enrolled in the Apple
  Developer Program. If there is real demand for notarized builds, I am open to signing and
  notarizing releases with an Apple Developer ID — please open or react to an
  [issue](../../issues) to let me know.
- **Don't want to pipe `curl` to `sh`?** You can inspect [`install.sh`](install.sh) before running
  it, or skip it altogether and install the zip by hand from [Releases](../../releases) using the
  steps above.
- **Closed source**: the source repository is private; this repository only distributes the
  released app and installer.
- **Network & telemetry**: Bowerbird has no accounts, no analytics, and no telemetry. It only
  connects to the network when:
  - checking for or downloading updates from this repository's GitHub Releases,
  - fetching a web page you explicitly save as a bookmark (saved pages have scripts and external
    references stripped), or
  - syncing with Google Drive (`drive.file` scope) if you choose to connect it.
- **Local HTTP API**: binds to `127.0.0.1` only, requires bearer tokens (with separate read-only
  and read-write tokens), and only returns CORS headers to browser extensions.
- **Encryption**: encrypted libraries protect files and metadata locally with AES-GCM and a
  32-byte master key backed by a 24-word BIP39 recovery phrase.

## Feedback

Bug reports, questions, and feature requests are welcome in [Issues](../../issues).

Bowerbird is not affiliated with Eagle.
