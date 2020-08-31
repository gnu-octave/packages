---
layout: "package"
description: >-
  Example package to demonstrate the creation process of an Octave package.
  Keep the description brief and tell about features of your package.
  Multiple lines are allowed, but each line no longer than 80 characters.
  Exceptions are URLs.  Line breaks are replaced by spaces later.
homepage: "https://github.com/gnu-octave/pkg-example"
icon: "https://raw.githubusercontent.com/gnu-octave/pkg-example/master/doc/icon.png"
license: "GPLv3+"
maintainers:
- name: "Kai T. Ohlhus"
  contact: "k.ohlhus@gmail.com"
- name: "Another Contactless Developer"
  contact:
versions:
- id: "0.0.1"
  date: "2020-08-31"
  sha256: "0b0bf67b45a20e95c89960b09a06e282c49e6d34a8fa22acac68452e4bd61d7d"
  url: "https://github.com/gnu-octave/pkg-example/archive/0.0.1.tar.gz"
  depends:
  - name: "octave"
    min: "4.2.0"
    max: "5.1.0"
- id: "dev"
  date:
  sha256:
  url: "https://github.com/gnu-octave/pkg-example/archive/master.zip"
  depends:
  - name: "octave"
    min: "5.2.0"
    max:
---
