#!/bin/bash
set -euo pipefail

ROOT="/Volumes/DevDisk/Developer/lucasilverentand/artemis-lunar-desktop"
SOURCE="$ROOT/source"
IMAGES_JSON="$ROOT/images.json"

# Output structure: output/<name>/desktop/ and output/<name>/phone/
OUTPUT="$ROOT/output"

# Desktop resolutions (landscape)
declare -A DESKTOP=(
  ["5k"]="5120x2880"
  ["4k"]="3840x2160"
  ["1080p"]="1920x1080"
)

# Phone resolutions (portrait)
declare -A PHONE=(
  ["iphone-16-pro-max"]="1320x2868"
  ["iphone-16-pro"]="1206x2622"
  ["iphone-16"]="1179x2556"
  ["iphone-se"]="750x1334"
  ["samsung-galaxy-s24-ultra"]="1440x3120"
  ["google-pixel-9-pro"]="1344x2992"
)

# Read images.json entries
count=$(jq length "$IMAGES_JSON")

for ((i = 0; i < count; i++)); do
  src=$(jq -r ".[$i].source" "$IMAGES_JSON")
  name=$(jq -r ".[$i].name" "$IMAGES_JSON")
  srcpath="$SOURCE/$src"

  if [ ! -f "$srcpath" ]; then
    echo "SKIP: $src not found"
    continue
  fi

  echo "Processing: $name ($src)"

  # Desktop variants
  for label in "${!DESKTOP[@]}"; do
    res="${DESKTOP[$label]}"
    outdir="$OUTPUT/$name/desktop"
    mkdir -p "$outdir"
    outfile="$outdir/${name}-${label}.jpg"

    if [ -f "$outfile" ]; then
      echo "  EXISTS: $outfile"
      continue
    fi

    # Center-crop to target aspect ratio, then resize
    magick "$srcpath" \
      -resize "${res}^" \
      -gravity center \
      -extent "$res" \
      -quality 92 \
      -sampling-factor 4:2:0 \
      -strip \
      "$outfile"

    echo "  -> $label ($res)"
  done

  # Phone variants (portrait crop from landscape source)
  for label in "${!PHONE[@]}"; do
    res="${PHONE[$label]}"
    outdir="$OUTPUT/$name/phone"
    mkdir -p "$outdir"
    outfile="$outdir/${name}-${label}.jpg"

    if [ -f "$outfile" ]; then
      echo "  EXISTS: $outfile"
      continue
    fi

    # For portrait: crop center of source to portrait aspect, then resize
    magick "$srcpath" \
      -resize "${res}^" \
      -gravity center \
      -extent "$res" \
      -quality 92 \
      -sampling-factor 4:2:0 \
      -strip \
      "$outfile"

    echo "  -> $label ($res)"
  done
done

echo ""
echo "Done! Output in: $OUTPUT"
echo "Total images: $(find "$OUTPUT" -name '*.jpg' | wc -l | tr -d ' ')"
