---
category: article
title: Nix Quickstart - for people in a hurry
---

## Install nix

```shell
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

## Try out a tool

```shell
nix-shell -p cowsay lolcat
```

There is no step three
