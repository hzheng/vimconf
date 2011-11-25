#!/bin/bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "******updating submodules..."
git submodule update --init

echo "******updating submodules' submodules..."
git submodule foreach git submodule update --init

echo "******installing command-t..."
(cd bundle/command-t/ruby/command-t && ruby extconf.rb && make) || echo "command-t installation failed"

echo "******installing pyflakes..."
(cd bundle/pyflakes/ftplugin/python/pyflakes && sudo python setup.py install) || echo "pyflakes installation failed"

read -p "Patch submodules(if you have done this before, press 'n' to skip)?(y/n) " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    patch -p0 -i "$DIR"/bundle.patch
fi
