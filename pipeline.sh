#!/usr/bin/env bash

packages=(antlr3 \
          antlr3-devcontainer \
          documentation \
          documentation-devcontainer \
          devcontainer \
)

for package in "${packages[@]}"; do
  make all/$package
done
