# Filimo Route List for MikroTik

This repository creates MikroTik address-list files for routing Filimo traffic through a specific route table.

The project keeps source domains, generated IPs, and RouterOS updater scripts separate so updates can be refreshed safely.

## Data Source

The first version generates data from:

- configured Filimo-related domains in `config/domains.txt`
- certificate transparency results for `*.filimo.com`
- current DNS A records for discovered hostnames

Filimo can use CDN-style delivery, so generated IPs should be refreshed regularly. The builder filters private and reserved IPv4 addresses before writing public routing outputs.

## Address Lists

| File | RouterOS address list | Purpose |
| --- | --- | --- |
| `mikrotik-filimo-address-list.rsc` | `filimo` | Filimo IPv4 hosts for policy routing |
| `filimo-domains.txt` | - | Discovered Filimo hostnames |
| `filimo-hosts.txt` | - | Hostnames resolved by the builder |
| `filimo-ips.txt` | - | Public IPv4 addresses |
| `filimo-prefixes.txt` | - | Public IPv4 `/32` prefixes |

## Recommended Safe Install

The safe install script fetches the updater and scheduler, imports them, removes temporary files from MikroTik disk, and runs the updater once.

```routeros
/tool fetch url="https://raw.githubusercontent.com/mohavise/filimo-route-list/main/safe-install-filimo-small-router.rsc" dst-path=safe-install-filimo-small-router.rsc mode=https
/import file-name=safe-install-filimo-small-router.rsc
/file remove [find name=safe-install-filimo-small-router.rsc]
```

## Manual Install

Install only the updater script:

```routeros
/tool fetch url="https://raw.githubusercontent.com/mohavise/filimo-route-list/main/update-filimo-small-router.rsc" dst-path=update-filimo-small-router.rsc mode=https
/import file-name=update-filimo-small-router.rsc
/system script run update-filimo-small-router
```

## Automatic Router Updates

After importing the updater script, import the scheduler file:

```routeros
/tool fetch url="https://raw.githubusercontent.com/mohavise/filimo-route-list/main/scheduler-update-filimo-small-router.rsc" dst-path=scheduler-update-filimo-small-router.rsc mode=https
/import file-name=scheduler-update-filimo-small-router.rsc
```

Default router schedule:

| Scheduler | Time |
| --- | --- |
| Filimo updates | `04:00:00` daily |

You can change the scheduler time in RouterOS if another time is better for your network.

## Safety Logic

The updater script is designed to avoid deleting a good old address list when the new download is broken or empty.

Update flow:

```mermaid
flowchart TD
    A["Start update"] --> B["Download new list from GitHub"]
    B --> C{"Download OK?"}
    C -- "No" --> D["Keep old address list"]
    C -- "Yes" --> E{"File exists and size is OK?"}
    E -- "No" --> D
    E -- "Yes" --> F["Create backup address list"]
    F --> G["Delete current filimo list"]
    G --> H["Import new list"]
    H --> I{"Import OK and list has entries?"}
    I -- "No" --> J["Restore old filimo list from backup"]
    I -- "Yes" --> K["Delete backup and downloaded file"]
    J --> K
    K --> L["Finish"]
```

The temporary backup list is:

```text
filimo-backup-before-update
```

## Automatic GitHub List Updates

The repository includes a GitHub Actions workflow:

```text
.github/workflows/update.yml
```

It runs every day at `23:30 UTC`, matching the update timing style used by `Get-IP-Iran-evo`, and regenerates:

- `filimo-domains.txt`
- `filimo-hosts.txt`
- `filimo-ips.txt`
- `filimo-prefixes.txt`
- `mikrotik-filimo-address-list.rsc`

You can also run it manually from the GitHub Actions tab.

## Generate Lists Manually

Run from Git Bash on Windows or from any Bash shell:

```bash
./scripts/build-filimo.sh
```
