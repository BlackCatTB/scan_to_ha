# Scan to Paperless Add-on Repository

This repository provides a Home Assistant add-on that triggers HP scans and saves them directly to:

- `/share/paperless/consume`

The add-on is built around:

- [`manuc66/node-hp-scan-to`](https://github.com/manuc66/node-hp-scan-to)

## Included Add-on

- `hp_scan_to_paperless` - Trigger scan jobs from Home Assistant (button, voice, scripts, automations) using `hassio.addon_stdin`.

## Installation

### Option A: Local add-on repository (recommended for testing)

1. Place this folder inside your Home Assistant local add-ons directory as:
   - `/addons/local/scan_to_ha`
2. In Home Assistant, go to **Settings -> Add-ons -> Add-on Store**.
3. Open the menu and click **Check for updates**.
4. Open add-on **HP Scan to Paperless Trigger**, install it, then start it.

### Option B: GitHub repository

1. Push this folder to a GitHub repository.
2. In Home Assistant, go to **Settings -> Add-ons -> Add-on Store**.
3. Add your repository URL in **Repositories**.
4. Install **HP Scan to Paperless Trigger**.

## Next Step

After install, read add-on docs in:

- `hp_scan_to_paperless/DOCS.md`
