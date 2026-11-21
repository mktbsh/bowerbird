# Bowerbird

A local-first alternative to [Eagle](https://eagle.cool) for macOS: collect images, videos and
other references, then sort them with folders, tags and smart folders and find them again by
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

1. Download the latest `Bowerbird-<version>.zip` from [Releases](../../releases) and unzip it.
2. Move `Bowerbird.app` to `/Applications`.
3. The app is signed with its own certificate, not an Apple Developer ID, so Gatekeeper stops the
   first launch. Clear the download flag once:

   ```sh
   xattr -dr com.apple.quarantine /Applications/Bowerbird.app
   ```

After that the app checks this repository's releases and updates itself (Settings ▸ About ▸
Updates). It only installs builds signed with the same certificate.

Versions are release dates: `YYYY.M.D`, with `.N` for a later release the same day.

Requires macOS 14 or later on Apple silicon.

Bowerbird is not affiliated with Eagle.
