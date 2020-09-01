# Package contribution guidelines

This guide explains how to add a package to this package index.


## Quick info

- A package entry in this index is managed by a single file,
  `package/pkg-example.md`, for an example package called "pkg-example".
  The content is [Markdown](https://en.wikipedia.org/wiki/Markdown)
  embedding [YAML](https://en.wikipedia.org/wiki/YAML) data.

- Adding or updating your package is done by a
  [**pull request**](https://docs.github.com/en/github/getting-started-with-github/github-glossary#pull-request).
  The pull request is reviewed
  [automatically by TravisCI](https://travis-ci.org/github/gnu-octave/pkg-index)
  and has to be approved and merged manually by a member of the
  [GitHub "gnu-octave" organization](https://github.com/orgs/gnu-octave/people).
  If the automatic review fails, it is less likely that your contribution will
  be accepted.


## Add your package

- Copy the *example package index entry* below and adapt it to your package.

- Create file `package/<my package>.md` with the name of your package in the
  [package](https://github.com/gnu-octave/pkg-index/tree/master/package)
  subdirectory.

  To do this, either use the "easy" way by following the
  [GitHub guide how to create a new file](https://docs.github.com/en/github/managing-files-in-a-repository/creating-new-files)
  ...

  ... or for experts:
  - fork <https://github.com/gnu-octave/pkg-index>
  - clone your fork `https://github.com/<my username>/pkg-index`
  - add `package/<my package>.md`
  - commit and push the changes to your fork
  - finally [create a pull request](https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request).


## Update your package

- For example after a new release of your package you can update the index
  entry by editing the file `package/<my package>.md` with the name of your
  package in the
  [package](https://github.com/gnu-octave/pkg-index/tree/master/package)
  subdirectory.

  To do this, either use the "easy" way by following the
  [GitHub guide how to edit files](https://docs.github.com/en/github/managing-files-in-a-repository/editing-files-in-your-repository)
  and the
  [GitHub guide how to edit files in other repositories](https://docs.github.com/en/github/managing-files-in-a-repository/editing-files-in-another-users-repository)
  ...

  ... or expert users can work in a fork as described above.


## Example package index entry

An example package index entry `package/pkg-example.md`:

```yaml
---
layout: "package"
description: >-
  Example package to demonstrate the creation process of an Octave package.
  Keep this description brief.  Describe the major features in the first two
  lines (160 characters).

  Multiple lines are allowed.  Each line may have maximal 80 characters.
  Exceptions are URLs.  Paragraphs, blank lines, and line breaks are ignored
  and replaced by spaces.
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
```

## Details

```
# sha256sum pkg-example-0.0.1.tar.gz

0b0bf67b45a20e95c89960b09a06e282c49e6d34a8fa22acac68452e4bd61d7d  pkg-example-0.0.1.tar.gz
```
