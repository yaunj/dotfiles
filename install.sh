#!/bin/bash
cd $(dirname $0)
GITREPO="${PWD}"

check_link()
{
    target=${1}
    link_name=${2}

    if [ -e "${link_name}" ]; then
        if [ -L "${link_name}" ]; then
            # Suppress error if link_name already points to destination
            end=$(python -c "import os; print os.path.realpath('${link_name}');")
            if [ "${end}" != "${target}" ]; then
                echo "[FAIL] ${link_name} is a link and points elsewhere." >&2
            fi
        else
            echo "[FAIL] ${link_name} is an existing file" >&2
        fi

        return 1
    else
        return 0
    fi
}

for f in *; do
    [[ "${f}" = "${0}" ]] && continue
    [[ "${f:0:6}" = "README" ]] && continue
    link=${HOME}/.${f}
    this=${PWD}/${f}

    if [ -f "${this}" ]; then
        # This is one of the toplevel files in the repository.
        # Try to symlink from $HOME
        if check_link "${this}" "${link}"; then
            ln -s "${this##${HOME}/}" "${link}"
            echo "[ OK ] Created $link" >&2
        fi
    elif [ -d "${this}" ]; then
        # This is a directory at the toplevel of the repository
        # Find all files, and symlink just the files
        for subfile in $(find "${this}" -type f); do
            link="${HOME}/.${subfile##${GITREPO}/}"
            if check_link "${subfile}" "${link}"; then
                mkdir -p "$(dirname "${subfile}")" 2>/dev/null
                ln -s "${subfile}" "${link}"
                echo "[ OK ] Created $link" >&2
            fi
        done
    fi
done
