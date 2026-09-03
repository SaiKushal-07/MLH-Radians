#!/bin/bash

git clone https://github.com/flutter/flutter.git -b stable --depth 1 _flutter_sdk

export PATH="$PATH:$(pwd)/_flutter_sdk/bin"

flutter config --enable-web

flutter pub get

printf 'GEMINI_API_KEY=%s\n' "$GEMINI_API_KEY" > .env

flutter build web --release