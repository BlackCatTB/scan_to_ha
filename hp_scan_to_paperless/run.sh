#!/usr/bin/with-contenv bashio
set -euo pipefail

APP_BIN="$(command -v node-hp-scan-to || true)"
TARGET_ARGS=()
SCAN_ARGS=()

is_value_set() {
    local value="${1:-}"
    [[ -n "${value}" && "${value}" != "null" ]]
}

build_target_args() {
    TARGET_ARGS=()

    local printer_ip
    local printer_name

    printer_ip="$(bashio::config 'printer_ip')"
    printer_name="$(bashio::config 'printer_name')"

    if is_value_set "${printer_ip}"; then
        TARGET_ARGS+=(--address "${printer_ip}")
        return
    fi

    if is_value_set "${printer_name}"; then
        TARGET_ARGS+=(--name "${printer_name}")
        return
    fi

    bashio::log.fatal "Set either printer_ip or printer_name in the add-on options."
    exit 1
}

build_scan_args() {
    SCAN_ARGS=()

    local output_directory
    local resolution
    local mode
    local file_pattern

    output_directory="$(bashio::config 'output_directory')"
    resolution="$(bashio::config 'resolution')"
    mode="$(bashio::config 'mode')"
    file_pattern="$(bashio::config 'file_pattern')"

    mkdir -p "${output_directory}"

    SCAN_ARGS+=(--directory "${output_directory}")
    SCAN_ARGS+=(--resolution "${resolution}")
    SCAN_ARGS+=(--mode "${mode}")

    if is_value_set "${file_pattern}"; then
        SCAN_ARGS+=(--pattern "${file_pattern}")
    fi

    if bashio::config.true 'duplex'; then
        SCAN_ARGS+=(--duplex)
    fi

    if bashio::config.true 'pdf'; then
        SCAN_ARGS+=(--pdf)
    fi

    if bashio::config.true 'prefer_escl'; then
        SCAN_ARGS+=(--prefer-eSCL)
    fi

    if bashio::config.true 'keep_files'; then
        SCAN_ARGS+=(--keep-files)
    fi

    if bashio::config.true 'debug'; then
        SCAN_ARGS+=(--debug)
    fi
}

run_single_scan() {
    build_target_args
    build_scan_args

    bashio::log.info "Triggering single scan job..."
    "${APP_BIN}" single-scan "${TARGET_ARGS[@]}" "${SCAN_ARGS[@]}"
    bashio::log.info "Scan job completed."
}

clear_registrations() {
    build_target_args

    local extra_args=()
    if bashio::config.true 'debug'; then
        extra_args+=(--debug)
    fi

    bashio::log.info "Clearing saved scan registrations on printer..."
    "${APP_BIN}" clear-registrations "${TARGET_ARGS[@]}" "${extra_args[@]}"
    bashio::log.info "Printer registrations cleared."
}

print_help() {
    bashio::log.info "Supported stdin commands:"
    bashio::log.info "  scan | single-scan | trigger  -> Start one scan"
    bashio::log.info "  clear | clear-registrations   -> Clear scan registrations on printer"
    bashio::log.info "  help                          -> Show this list"
}

handle_command() {
    local raw_command="${1:-}"
    local command="${raw_command,,}"

    case "${command}" in
        ""|scan|single-scan|trigger)
            run_single_scan
            ;;
        clear|clear-registrations)
            clear_registrations
            ;;
        help)
            print_help
            ;;
        *)
            bashio::log.warning "Unknown command: ${raw_command}"
            print_help
            ;;
    esac
}

if [[ -z "${APP_BIN}" || ! -x "${APP_BIN}" ]]; then
    bashio::log.fatal "node-hp-scan-to executable was not found in PATH."
    exit 1
fi

build_target_args

bashio::log.info "HP Scan to Paperless Trigger add-on started."
bashio::log.info "Use Home Assistant service hassio.addon_stdin with input 'scan' to trigger a scan."

while true; do
    if read -r -t 3600 command_line; then
        command_line="${command_line%$'\r'}"
        handle_command "${command_line}"
    fi
done
