# HP Scan to Paperless Trigger

This add-on uses `node-hp-scan-to` to trigger a scan from your HP printer and write output into a folder that Paperless-ngx consumes.

Default output folder:

- `/share/paperless/consume`

## How it works

- The add-on runs continuously.
- It waits for commands from Home Assistant via `hassio.addon_stdin`.
- Send `scan` to trigger one scan job.

## Configuration

### Required

Set one of:

- `printer_ip`: IP address of your printer (recommended in Docker/add-ons)
- `printer_name`: printer hostname for network lookup

### Important defaults

- `output_directory`: `/share/paperless/consume`
- `pdf`: `true`
- `resolution`: `300`

## Trigger from Home Assistant

### 1. Create script

Use a script that sends `scan` to the add-on.

```yaml
script:
  scan_to_paperless:
    alias: Scan to Paperless
    mode: single
    sequence:
      - action: hassio.addon_stdin
        data:
          addon: local_hp_scan_to_paperless
          input: scan
```

Notes:

- If your add-on slug differs, replace `local_hp_scan_to_paperless` with your actual add-on ID.
- You can find it in the add-on details page under Supervisor information.

### 2. Trigger with a button (example)

```yaml
automation:
  - alias: Scan to Paperless Button
    triggers:
      - trigger: state
        entity_id: input_button.scan_to_paperless
    actions:
      - action: script.scan_to_paperless
```

You can also trigger the same script from any Zigbee/Z-Wave button automation.

### 3. Trigger with voice (Assist conversation trigger)

```yaml
automation:
  - alias: Scan to Paperless Voice
    triggers:
      - trigger: conversation
        command:
          - scan my documents
          - scan to paperless
    actions:
      - action: script.scan_to_paperless
```

## Supported stdin commands

- `scan` or `single-scan`: Run one scan
- `clear` or `clear-registrations`: Remove scan target registrations from printer
- `help`: Print command list in logs

## Notes for Raspberry Pi 4

- This add-on supports `aarch64` and `armv7` architectures.
- `host_network` is enabled so discovery can work more reliably if you use printer name lookup.
- For best reliability in containers, `printer_ip` is recommended.
