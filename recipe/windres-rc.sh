#!/usr/bin/env bash
set -euo pipefail

args=()
next_is_out=0

for arg in "$@"; do
    if [[ $next_is_out -eq 1 ]]; then
        # rc.exe strictly requires /fo directly glued to the path (no space)
        args+=("/fo$arg")
        next_is_out=0
        continue
    fi

    case "$arg" in
        -o)
            next_is_out=1
            ;;
        -o*)
            # Handle -ofilename.obj
            out_file="${arg#-o}"
            args+=("/fo${out_file}")
            ;;
        -i)
            # Ignore windres input flag (rc accepts input file positionally)
            ;;
        -D*)
            # Map -D to /d
            args+=("${arg/-D//d}")
            ;;
        -I*)
            # Map -I to /i
            args+=("${arg/-I//i}")
            ;;
        --output-format=*|-O*)
            # Drop GNU windres format flags
            ;;
        *)
            args+=("$arg")
            ;;
    esac
done
set -x
exec rc.exe "${args[@]}"