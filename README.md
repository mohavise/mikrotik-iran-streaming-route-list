# Filimo Route List

Bash-built Filimo domain/IP database for MikroTik routing.

This repo creates refreshable lists for routing Filimo traffic through a specific route table.

## Outputs

- `filimo-domains.txt`
- `filimo-hosts.txt`
- `filimo-ips.txt`
- `filimo-prefixes.txt`
- `mikrotik-filimo-address-list.rsc`

## Build

```bash
./scripts/build-filimo.sh
```

On Windows, run it from Git Bash.

## MikroTik

Import:

```routeros
/import file-name=mikrotik-filimo-address-list.rsc
```

Address list name:

```routeros
filimo
```

## Notes

Filimo can use CDN-style delivery, so generated IPs should be refreshed regularly. The builder filters private and reserved IPv4 addresses before writing public routing outputs.
