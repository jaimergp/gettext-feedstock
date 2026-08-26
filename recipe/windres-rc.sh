#!/usr/bin/env bash
# Translates GNU windres flags to MSVC rc.exe flags
args=()
for arg in "$@"; do
    case "$arg" in
        -i) ;; # Ignore GNU input flag
        -o) args+=("/fo") ;; # Map output flag
        --output-format=*) ;; # Ignore format flag
        *) args+=("$arg") ;;
    esac
done
set -x
exec rc.exe "${args[@]}"
