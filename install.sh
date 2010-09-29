#!/bin/bash

for f in *; do
    [[ "${f}" = "${0}" ]] && continue
    link=${HOME}/.${f}
    this=${PWD}/${f}

    if [[ -e "${link}" ]]; then
        if [[ -L "${link}" ]]; then
            end=$(python -c "import os; print os.path.realpath('${f}');")

            if [[ "${end}" != "${this}" ]]; then
                echo "[FAIL] ${link} points elsewhere. Fix it yourself." >&2
            fi
        else
            echo "[FAIL] .${f} exists in \$HOME. Symlink it yourself." >&2
        fi
    else
        ln -s "${this}" "${link}"
        echo "[ OK ] Created $link" >&2
    fi
done
