#!/bin/bash
cd "$(dirname "$0")"
[ -d "./dist" ] && echo Removing ./dist && rm -rfv "./dist"
[ -f "./MANIFEST" ] && echo Removing ./MANIFEST && rm -rfv "./MANIFEST"
python3 setup.py sdist
twine upload dist/*