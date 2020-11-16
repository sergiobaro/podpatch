#!/usr/bin/env bash

swift build || exit 1
mv Podfile_multiline Podfile
if .build/debug/podpatch $@ ; then
    ruby -wc Podfile # check ruby syntax
fi
mv Podfile Podfile_multiline
