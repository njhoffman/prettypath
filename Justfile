# prettypath: install is the Makefile's (luarocks --local rock plus its launcher).

# list recipes
default:
    @just --list

# make install: `luarocks --local make` of the dev rockspec, then the launcher in luarocks' bin dir (~/.luarocks/bin/prettypath)
install:
    #!/usr/bin/env bash
    set -euo pipefail
    command -v luarocks >/dev/null || { echo "install: luarocks not found (~/.shell's deploy installs it)" >&2; exit 1; }
    make install

# exit 1 when the launcher or the rock is missing (deploy reinstalls then)
install-check:
    #!/usr/bin/env bash
    set -euo pipefail
    bin="$(luarocks --local config deploy_bin_dir)/prettypath"
    [[ -x $bin ]]
    luarocks --local show prettypath >/dev/null 2>&1

# the test suite (make test)
test:
    make test
