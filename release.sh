#!/usr/bin/env bash

swift build -c release || exit 1
current_version=$(git describe --tags `git rev-list --tags --max-count=1`)

vestion_regex="([0-9]+)\.([0-9]+)\.([0-9]+)"
if [[ $current_version =~ $vestion_regex ]]; then
    major="${BASH_REMATCH[1]}"
    minor="${BASH_REMATCH[2]}"
    patch="${BASH_REMATCH[3]}"
    next_patch=$((patch+1))
    next_version="${major}.${minor}.${next_patch}"
    echo "Current version: $current_version"
    echo "Next version: $next_version"
    if git tag $next_version; then
        git push origin $next_version
    fi
else 
    echo "Tag not found."
fi


