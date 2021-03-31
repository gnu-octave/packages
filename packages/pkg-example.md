---
layout: "package"
description: >-
  Example package to demonstrate the creation process of an Octave package.
  Keep this description brief.  Describe the major features in the first two
  lines (160 characters).

  Multiple lines are allowed.  Each line may have maximal 80 characters.
  Exceptions are URLs.  Paragraphs, blank lines, and line breaks are ignored
  and replaced by spaces.
icon: "https://raw.githubusercontent.com/gnu-octave/pkg-example/master/doc/icon.png"
links:
- icon: "far fa-copyright"
  label: "GPL-3.0-or-later"
  url: "https://github.com/gnu-octave/pkg-example/blob/master/COPYING"
- icon: "fas fa-rss"
  label: "news"
  url: "https://github.com/gnu-octave/pkg-example/releases/"
- icon: "fas fa-code-branch"
  label: "repository"
  url: "https://github.com/gnu-octave/pkg-example/"
- icon: "fas fa-book"
  label: "package documentation"
  url: "https://github.com/gnu-octave/pkg-example/blob/master/README.md"
- icon: "fas fa-bug"
  label: "report a problem"
  url: "https://github.com/gnu-octave/pkg-example/issues"
maintainers:
- name: "Kai T. Ohlhus"
  contact: "k.ohlhus@gmail.com"
- name: "Another Contactless Developer"
  contact:
versions:
- id: "1.0.0"
  date: "2020-09-02"
  sha256: "6b7e4b6bef5a681cb8026af55c401cee139b088480f0da60143e02ec8880cb51"
  url: "https://github.com/gnu-octave/pkg-example/archive/1.0.0.tar.gz"
  depends:
  - "octave (>= 4.2.0)"
- id: "dev"
  date:
  sha256:
  url: "https://github.com/gnu-octave/pkg-example/archive/master.zip"
  depends:
  - "octave (>= 5.2.0)"
---
