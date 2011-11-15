#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "******updating submodules..."
git submodule update --init

echo "******updating submodules' submodules..."
git submodule foreach git submodule update --init

echo "******installing command-t..."
(cd bundle/command-t/ruby/command-t && ruby extconf.rb && make) || echo "command-t installation failed"

echo "******installing pyflakes..."
(cd bundle/pyflakes/ftplugin/python/pyflakes && python setup.py install) || echo "pyflakes installation failed"

echo "******patching submodules"
patch -p0 -i $DIR/bundle.patch
