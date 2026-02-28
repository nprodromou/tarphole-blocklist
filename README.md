# TarpHole Blocklist

Curated DNS blocklist for [TarpHole](https://github.com/nprodromou/tarphole) — a Cloudflare Zero Trust Gateway DNS management UI.

## What Is This?

This repository contains a curated DNS blocklist optimized for Cloudflare Gateway's 100,000 domain limit (free plan). The list is regenerated weekly from upstream sources and published here for transparency and reproducibility.

## Selected List: Hagezi Pro Mini

**Source:** [Hagezi DNS Blocklists](https://github.com/hagezi/dns-blocklists) — Pro tier, Mini variant

| Attribute | Value |
|-----------|-------|
| Domains | ~76,000 |
| Update frequency | Weekly (via GitHub Action) |
| Categories blocked | Ads, tracking, malware, phishing, scam, cryptojacking, error trackers |
| False positive rate | Low (Pro tier is maintainer's recommended default) |
| Upstream sources | 300+ aggregated lists |

### Why Hagezi Pro Mini?

We evaluated 9 major DNS blocklists against these criteria:

1. **Coverage** — what percentage of real-world ad/tracking/malware requests does it block?
2. **False positive rate** — does it break legitimate sites?
3. **Update frequency** — how actively maintained is it?
4. **Fit** — does it fit within Cloudflare Gateway's 95k entry budget (100k total minus 5k reserved for user lists)?

| List | Domains | Fits 95k? | Verdict |
|------|---------|-----------|---------|
| **Hagezi Pro Mini** | **76,363** | **Yes** | **Selected** — best coverage-per-domain |
| Steven Black Unified | 77,525 | Yes | Runner-up — fewer categories (ads + malware only) |
| OISD Small | 56,412 | Yes | Too conservative — ads only |
| 1Hosts Lite | 205,036 | No | Over budget |
| Hagezi Light | 123,602 | No | Over budget |
| Hagezi Normal | 295,259 | No | Over budget |
| Hagezi Pro (full) | 388,886 | No | Over budget — Mini variant is the solution |
| OISD Big | 387,299 | No | Over budget |
| Hagezi Ultimate | 511,867 | No | Over budget |

**Key insight:** Hagezi Pro Mini is filtered from the full 389k Pro list to include only domains that appear in Top 1M/10M domain popularity rankings (Umbrella, Cloudflare, Tranco, Chrome, BuiltWith, Majestic, DomCop). This means every domain in the list is relevant and commonly encountered — no long-tail domains that waste entries.

No two-list combination fits within the 95k budget after deduplication (overlap between lists is surprisingly small — only 4,000–14,000 domains shared).

### Capacity Budget

| Allocation | Entries | CF Lists |
|------------|---------|----------|
| Curated blocklist (this repo) | ~76,363 | ~77 |
| User blacklist (managed in TarpHole UI) | ~3,000–4,000 | ~3–4 |
| User whitelist (managed in TarpHole UI) | ~1,000–2,000 | ~1–2 |
| Remaining headroom | ~16,637–18,637 | ~17–19 |
| **Total Cloudflare Gateway budget** | **100,000** | **100** |

## Files

| File | Description |
|------|-------------|
| `blocklist.txt` | The current curated blocklist (one domain per line) |
| `generate.sh` | Script to regenerate the blocklist from upstream sources |
| `metadata.json` | Generation metadata (date, source URL, domain count, checksum) |

## Regeneration

The blocklist is automatically regenerated every Monday at 06:00 UTC via GitHub Actions. You can also regenerate manually:

```bash
./generate.sh
```

This downloads the latest Hagezi Pro Mini list, validates it, and updates `blocklist.txt` and `metadata.json`.

## Using With TarpHole

Add this as a blocklist source in TarpHole's dashboard:

```
https://raw.githubusercontent.com/nprodromou/tarphole-blocklist/main/blocklist.txt
```

## License

The blocklist content is sourced from [Hagezi DNS Blocklists](https://github.com/hagezi/dns-blocklists) which is licensed under GPL v3.0. The generation tooling in this repository is licensed under MIT.
