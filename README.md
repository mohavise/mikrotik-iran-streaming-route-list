# Iran Streaming DNS Policy Routing for MikroTik

RouterOS DNS-static rules for learning Iranian streaming-service destination IPs into an address list for policy routing.

```text
service domain
→ MikroTik DNS static FWD rule
→ DST-IRAN-STREAMING-TO-OUTBOUND
→ mangle policy-routing rule
→ selected outbound path
```

## Design

This repository uses domains, not static IP ranges.

Generated rules look like:

```routeros
/ip dns static
add regexp="(^|.*\\.)filimo\\.com$" type=FWD address-list=DST-IRAN-STREAMING-TO-OUTBOUND comment="iran-streaming:filimo.com"
```

When clients resolve matching domains through MikroTik DNS, RouterOS adds the returned destination IPs to:

```text
DST-IRAN-STREAMING-TO-OUTBOUND
```

## Files

| File | Purpose |
| --- | --- |
| `services/iran-streaming/database/domains.txt` | Trusted root-domain database |
| `iran-streaming-domains.txt` | Validated generated domain list |
| `iran-streaming-urls.txt` | Deterministic HTTPS URL representation |
| `services/iran-streaming/output/list-all.rsc` | Generated RouterOS DNS-static rules |
| `safe-install-iran-streaming-small-router.rsc` | Updater and scheduler installer |
| `scripts/build-iran-streaming.sh` | Build and validation script |
| `scripts/discover-iran-streaming.py` | Optional public discovery enrichment |
| `.github/workflows/update.yml` | Scheduled GitHub workflow |

## Install

```routeros
/tool fetch url="https://raw.githubusercontent.com/mohavise/mikrotik-iran-streaming-route-list/main/safe-install-iran-streaming-small-router.rsc" dst-path="safe-install-iran-streaming-small-router.rsc" check-certificate=yes-without-crl
/import file-name="safe-install-iran-streaming-small-router.rsc"
/file remove [find name="safe-install-iran-streaming-small-router.rsc"]
```

The installer creates or updates:

```text
/system script     update-iran-streaming-outbound
/system scheduler  update-iran-streaming-outbound
```

Default schedule:

```text
04:01 daily
```

## RouterOS Requirements

Clients must use the MikroTik router as DNS:

```routeros
/ip dns set allow-remote-requests=yes
```

Provide the router DNS through DHCP or enforce it with DNS redirect rules.

## Update Safety

The installed updater performs:

```text
Export current managed rules
→ secure HTTPS download with certificate verification
→ RouterOS verbose dry-run import
→ real import
→ minimum-entry verification
→ clean rollback after partial or failed import
→ temporary-file cleanup
```

Only rules matching both of these identifiers are managed:

```text
address-list=DST-IRAN-STREAMING-TO-OUTBOUND
comment starts with iran-streaming:
```

## Build Validation

The repository build:

- normalizes domains to lowercase
- rejects malformed domains and IP addresses
- removes duplicates
- sorts output deterministically
- requires at least 20 domains
- blocks domain-count reductions greater than 20%
- verifies generated RouterOS entry count

Manual build:

```bash
./scripts/build-iran-streaming.sh
```

## Policy-Routing Example

Adjust the table and gateway for your environment:

```routeros
/routing table add name=to-outbound fib
/ip firewall mangle add chain=prerouting dst-address-list=DST-IRAN-STREAMING-TO-OUTBOUND action=mark-routing new-routing-mark=to-outbound passthrough=no comment="Iran streaming to outbound"
/ip route add dst-address=0.0.0.0/0 gateway=<YOUR-OUTBOUND-GATEWAY> routing-table=to-outbound
```

## GitHub Automation

The workflow runs daily at:

```text
23:30 UTC
```

It commits only when validated generated outputs change.
