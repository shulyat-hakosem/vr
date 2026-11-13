#!/usr/bin/env bash
# Add a VR project to the portal (prepended to projects.json, newest first).
# Usage:
#   ./add-project.sh --title "כותרת" --subtitle "תת-כותרת" --url "https://..." \
#       --date YYYY-MM-DD --status "חי" [--thumbnail /path/to/image.jpg]
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
TITLE="" SUBTITLE="" URL="" DATE="" STATUS="חי" THUMB=""

usage() {
  sed -n '2,6p' "$0" | sed 's/^# \?//'
  exit 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --title) TITLE="${2:-}"; shift 2 ;;
    --subtitle) SUBTITLE="${2:-}"; shift 2 ;;
    --url) URL="${2:-}"; shift 2 ;;
    --date) DATE="${2:-}"; shift 2 ;;
    --status) STATUS="${2:-}"; shift 2 ;;
    --thumbnail) THUMB="${2:-}"; shift 2 ;;
    -h|--help) usage ;;
    *) echo "Unknown argument: $1" >&2; usage ;;
  esac
done

if [[ -z "$TITLE" || -z "$URL" ]]; then
  echo "Required: --title and --url" >&2
  usage
fi
if [[ -z "$DATE" ]]; then
  DATE="$(date +%Y-%m-%d)"
fi

python3 - "$ROOT" "$TITLE" "$SUBTITLE" "$URL" "$DATE" "$STATUS" "$THUMB" <<'PY'
import json, os, shutil, sys
from pathlib import Path

root, title, subtitle, url, date, status, thumb = sys.argv[1:]
json_path = Path(root) / "projects.json"
data = json.loads(json_path.read_text(encoding="utf-8"))
projects = data.get("projects", [])

thumb_rel = ""
if thumb:
    src = Path(thumb)
    if not src.is_file():
        sys.exit(f"Thumbnail not found: {src}")
    dest_dir = Path(root) / "assets" / "thumbs"
    dest_dir.mkdir(parents=True, exist_ok=True)
    dest = dest_dir / src.name
    if src.resolve() != dest.resolve():
        shutil.copy2(src, dest)
    thumb_rel = f"assets/thumbs/{dest.name}"

entry = {
    "title": title,
    "subtitle": subtitle,
    "url": url,
    "date": date,
    "status": status,
}
if thumb_rel:
    entry["thumbnail"] = thumb_rel

# Prepend; the page also sorts by date, newest first.
projects.insert(0, entry)
data["projects"] = projects
json_path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
print(f"Added: {title}")
print(f"  url: {url}")
if thumb_rel:
    print(f"  thumbnail: {thumb_rel}")
print("Commit and push to update the live portal.")
PY
