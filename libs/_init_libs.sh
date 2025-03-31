#!/usr/bin/env bash

# Detect shell type
if [ -n "${ZSH_VERSION-}" ]; then
  LIBS_DIR="$(dirname "$(realpath "${(%):-%N}")")"
else
  LIBS_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
fi

# shellcheck source=libs/_branch.sh
source "${LIBS_DIR}"/_branch.sh

# shellcheck source=libs/_checkout.sh
source "${LIBS_DIR}"/_checkout.sh

# shellcheck source=libs/_utils.sh
source "${LIBS_DIR}"/_utils.sh

