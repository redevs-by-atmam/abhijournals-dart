#!/bin/bash
curl -fsSL https://dart.dev/get-dart | bash
export PATH="$PATH:/usr/lib/dart/bin"
dart pub get
dart run build_runner build
dart compile exe bin/main.dart -o server 