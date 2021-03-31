#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# If no file is given, check all packages.

if [ -z "$1" ]; then
  files="`cd "$DIR/../../packages" && pwd`/*"
else
  files=$1
fi

# Check YAML files in the "package" directory of this repository.

yamllint -c $DIR/yamllint.yaml $files
