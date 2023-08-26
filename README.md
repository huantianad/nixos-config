[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![NixOS Unstable](https://img.shields.io/badge/NixOS-unstable-blue.svg?style=flat-square&logo=NixOS&logoColor=white)](https://nixos.org)

**Hello!** 👋 Welcome to my NixOS configurations! Using the new funny flakes, and is constantly changing, perhpas sometimes for the worse, but hopefully for the working.

Heavily based off of [thise](https://github.com/hlissner/dotfiles) NixOS config, the base structure is the same, except I've made some modifications to better suit my needs. For example, allowing different hosts to have differnt Nixpkgs versions and architectures.

I expose some helpful things via flakes, probably the most useful would be some of my packages in `./packages/`, those are accessible as you'd expect, via `my-flake.packages."${system}.name` in case you'd ever want to use any of them! I try to upstream most of my packages to Nixpkgs, so you'll probably be able to find them there anyway.
