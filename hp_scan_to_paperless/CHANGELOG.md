# Changelog

## 0.1.1

- Fix startup behavior to avoid requiring printer target at container boot
- Add optional target override in stdin commands (for example: `scan 192.168.1.50`)
- Keep compatibility updates for Home Assistant s6-overlay startup

## 0.1.0

- Initial release
- Home Assistant add-on scaffold for `node-hp-scan-to`
- STDIN-triggered commands for Home Assistant automations
- Default output to `/share/paperless/consume`
