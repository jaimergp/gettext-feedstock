#!/usr/bin/env bash
set -euo pipefail

args=()
next_is_out=0

for arg in "$@"; do
    if [[ $next_is_out -eq 1 ]]; then
        args+=("/fo" "$arg")
        next_is_out=0
        continue
    fi

    case "$arg" in
        -o)
            next_is_out=1
            ;;
        -o*)
            out_file="${arg#-o}"
            args+=("/fo" "${out_file}")
            ;;
        -i)
            # Ignore windres input flag (rc accepts input file positionally)
            ;;
        -D*)
            macro="${arg#-D}"
            # Strip escaped quotes inside macro strings
            macro="${macro//\\\"/\"}"
            args+=("/d" "${macro}")
            ;;
        -I*)
            include_dir="${arg#-I}"
            args+=("/i" "${include_dir}")
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
