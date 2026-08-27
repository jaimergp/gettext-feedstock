#!/usr/bin/env bash
set -euo pipefail

flags=()
input_file=""

next_is_out=0

for arg in "$@"; do
    if [[ $next_is_out -eq 1 ]]; then
        flags+=("/fo" "$arg")
        next_is_out=0
        continue
    fi

    case "$arg" in
        -o)
            next_is_out=1
            ;;
        -o*)
            out_file="${arg#-o}"
            flags+=("/fo" "${out_file}")
            ;;
        -i)
            # Ignore windres input flag
            ;;
        -D*)
            macro="${arg#-D}"
            # Strip literal quote characters that break rc.exe /d flags
            macro="${macro//\"/}"
            flags+=("/d" "${macro}")
            ;;
        -I*)
            include_dir="${arg#-I}"
            flags+=("/i" "${include_dir}")
            ;;
        --output-format=*|-O*)
            # Drop GNU windres format flags
            ;;
        *.rc)
            input_file="$arg"
            ;;
        *)
            flags+=("$arg")
            ;;
    esac
done

set -x
# Ensure input file is passed strictly at the very end
if [[ -n "$input_file" ]]; then
    exec rc.exe "${flags[@]}" "$input_file"
else
    exec rc.exe "${flags[@]}"
fi
