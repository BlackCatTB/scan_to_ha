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

Set one of (recommended):

- `printer_ip`: IP address of your printer (recommended in Docker/add-ons)
- `printer_name`: printer hostname for network lookup

If you do not set either option, the add-on will still start. In that case, pass printer IP in the trigger input (example: `scan 192.168.1.50`).

### Important defaults

- `output_directory`: `/share/paperless/consume`
- `pdf`: `true`
- `resolution`: `300`

## Trigger from Home Assistant

Fast test from Developer Tools:

1. Open **Developer Tools -> Actions**.
2. Action: `hassio.addon_stdin`
3. Data:

```yaml
addon: local_hp_scan_to_paperless
input: scan
```

If you did not configure `printer_ip` or `printer_name`, use:

```yaml
addon: local_hp_scan_to_paperless
input: scan 192.168.1.50
```

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

You can also override the printer at trigger time:

```yaml
script:
  scan_to_paperless_with_ip:
    alias: Scan to Paperless with Printer IP
    sequence:
      - action: hassio.addon_stdin
        data:
          addon: local_hp_scan_to_paperless
          input: scan 192.168.1.50
```

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
- `scan <printer-ip>`: Run one scan against explicit printer IP
- `clear` or `clear-registrations`: Remove scan target registrations from printer
- `clear <printer-ip>`: Clear registrations on explicit printer IP
- `help`: Print command list in logs

## Notes for Raspberry Pi 4

- This add-on supports `aarch64` and `armv7` architectures.
- `host_network` is enabled so discovery can work more reliably if you use printer name lookup.
- For best reliability in containers, `printer_ip` is recommended.
