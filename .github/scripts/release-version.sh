#!/bin/bash

is_numeric_semver() {
  [[ "${1:-}" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]
}

package_version_from_json() {
  python3 -c 'import json,sys; print(json.load(sys.stdin)["version"])'
}

next_minor_version() {
  local version="$1"
  if ! is_numeric_semver "$version"; then
    echo "Invalid semver: ${version:-<empty>}" >&2
    return 1
  fi

  local major minor patch
  IFS=. read -r major minor patch <<< "$version"
  if [ "$patch" -ne 0 ]; then
    echo "Version ${version} is not a minor release (patch must be 0)." >&2
    return 1
  fi

  echo "${major}.$((minor + 1)).0"
}
