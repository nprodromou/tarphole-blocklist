#!/usr/bin/env bash
# TarpHole Blocklist Generator
# Downloads Hagezi Pro Mini and produces a clean domain list for Cloudflare Gateway.

set -euo pipefail

PRIMARY_URL="https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/wildcard/pro.mini-onlydomains.txt"
MIRROR_URL="https://gitlab.com/hagezi/mirror/-/raw/main/dns-blocklists/wildcard/pro.mini-onlydomains.txt"
OUTPUT="blocklist.txt"
METADATA="metadata.json"

echo "==> Downloading Hagezi Pro Mini..."
if ! curl -fsSL "$PRIMARY_URL" -o raw_list.txt; then
    echo "    Primary failed, trying mirror..."
    curl -fsSL "$MIRROR_URL" -o raw_list.txt
fi

echo "==> Cleaning list..."
# Remove comments, blank lines, leading/trailing whitespace
grep -v '^#' raw_list.txt \
    | grep -v '^\s*$' \
    | sed 's/^[[:space:]]*//' \
    | sed 's/[[:space:]]*$//' \
    | tr '[:upper:]' '[:lower:]' \
    | sort -u \
    > "$OUTPUT"

DOMAIN_COUNT=$(wc -l < "$OUTPUT" | tr -d ' ')
CHECKSUM=$(shasum -a 256 "$OUTPUT" | awk '{print $1}')
GENERATED_AT=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

echo "==> Writing metadata..."
cat > "$METADATA" <<EOF
{
  "generated_at": "$GENERATED_AT",
  "source": "Hagezi Pro Mini",
  "source_url": "$PRIMARY_URL",
  "mirror_url": "$MIRROR_URL",
  "domain_count": $DOMAIN_COUNT,
  "sha256": "$CHECKSUM"
}
EOF

rm -f raw_list.txt

echo "==> Done: $DOMAIN_COUNT domains in $OUTPUT"
