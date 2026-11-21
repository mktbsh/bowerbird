#!/bin/sh
# Installs or updates Bowerbird from the latest release of mktbsh/bowerbird.
#
#   curl -fsSL https://raw.githubusercontent.com/mktbsh/bowerbird/main/install.sh | sh
#
# The zip is fetched with curl, so macOS does not mark it as downloaded and Gatekeeper does not
# stop the first launch. Instead, the app is installed only if it is signed with the certificate
# every release is signed with (its SHA-1 is below).
#
#   BOWERBIRD_INSTALL_DIR=~/Applications   install somewhere other than /Applications
set -eu

repo=mktbsh/bowerbird
app_name=Bowerbird
bundle_id=app.bowerbird.macos
cert_sha1=A8CE2558390C191B685C7B926A1DCFFF9FF0C727
dest=${BOWERBIRD_INSTALL_DIR:-/Applications}

fail() { echo "install.sh: $*" >&2; exit 1; }

[ "$(uname -s)" = Darwin ] || fail "Bowerbird runs on macOS only."
[ "$(uname -m)" = arm64 ] || fail "Bowerbird needs a Mac with Apple silicon."
[ "$(sw_vers -productVersion | cut -d. -f1)" -ge 14 ] || fail "Bowerbird needs macOS 14 or later."
[ -d "$dest" ] && [ -w "$dest" ] || fail "$dest is not writable. Try: BOWERBIRD_INSTALL_DIR=~/Applications"

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

echo "Looking up the latest release…"
# github.com/<repo>/releases/latest redirects to .../releases/tag/<tag>.
latest=$(curl -fsSL -o /dev/null -w '%{url_effective}' "https://github.com/$repo/releases/latest") \
    || fail "could not reach GitHub."
tag=${latest##*/}
printf '%s' "$tag" | grep -Eq '^v[0-9]{4}\.[0-9]{1,2}\.[0-9]{1,2}(\.[0-9]+)?$' || fail "unexpected tag: $tag"
version=${tag#v}

target="$dest/$app_name.app"
if [ -d "$target" ]; then
    installed=$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$target/Contents/Info.plist" 2>/dev/null || true)
    if [ "$installed" = "$version" ]; then
        echo "$app_name $version is already installed in $dest."
        exit 0
    fi
fi

zip="$app_name-$version.zip"
echo "Downloading ${zip}…"
curl -fL --progress-bar -o "$work/$zip" "https://github.com/$repo/releases/download/$tag/$zip" \
    || fail "could not download $zip."
mkdir "$work/unzipped"
ditto -x -k "$work/$zip" "$work/unzipped" || fail "$zip could not be unpacked."
app="$work/unzipped/$app_name.app"
[ -d "$app" ] || fail "$zip does not hold $app_name.app."

echo "Checking the signature…"
codesign --verify --deep --strict \
    -R="identifier \"$bundle_id\" and certificate leaf = H\"$cert_sha1\"" "$app" 2>/dev/null \
    || fail "$zip is not signed with the Bowerbird release certificate. Nothing was installed."
[ "$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$app/Contents/Info.plist")" = "$version" ] \
    || fail "$zip is not version $version. Nothing was installed."

# Copy next to the destination, then swap by rename, so the installed app is never half-written.
# A running copy keeps reading from the bundle that is moved aside and offers to relaunch.
staged="$dest/.$app_name.app.installing"
rm -rf "$staged"
ditto "$app" "$staged"
if [ -e "$target" ]; then
    previous="${TMPDIR:-/tmp}/bowerbird-previous.app"
    rm -rf "$previous"
    mv "$target" "$previous"
fi
mv "$staged" "$target"

echo "Installed $app_name $version in $dest."
if pgrep -x "$app_name" >/dev/null 2>&1; then
    echo "$app_name is running: use Relaunch at the bottom of its sidebar to switch to $version."
else
    open "$target"
fi
