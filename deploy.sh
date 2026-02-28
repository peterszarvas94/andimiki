#!/usr/bin/env bash
set -euo pipefail

REMOTE="${REMOTE:-peti@shared}"
REMOTE_DIR="${REMOTE_DIR:-/var/www/andiesmiki.hu}"
DRY_RUN="${1:-}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

required_files=("index.html" "img1.jpeg" "img2.jpeg")
upload_files=()

for file in "${required_files[@]}"; do
  if [[ ! -f "$file" ]]; then
    printf "Missing required file: %s\n" "$file" >&2
    exit 1
  fi
done

shopt -s nullglob
for pattern in *.html *.jpeg *.jpg *.png *.svg *.webp *.ico; do
  upload_files+=("$pattern")
done
shopt -u nullglob

if [[ ${#upload_files[@]} -eq 0 ]]; then
  printf "No deployable files found in %s\n" "$SCRIPT_DIR" >&2
  exit 1
fi

printf "Deploy target: %s:%s\n" "$REMOTE" "$REMOTE_DIR"
printf "Files:\n"
for file in "${upload_files[@]}"; do
  printf -- "- %s\n" "$file"
done

if [[ "$DRY_RUN" == "--dry-run" ]]; then
  printf "Dry run only. No files uploaded.\n"
  exit 0
fi

ssh "$REMOTE" "mkdir -p '$REMOTE_DIR'"
scp "${upload_files[@]}" "$REMOTE:$REMOTE_DIR/"
ssh "$REMOTE" "ls -lah '$REMOTE_DIR'"

printf "Deploy complete.\n"
