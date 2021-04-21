# Octave Packages contribution guidelines

This guide explains how to add your Octave package or toolbox to
<https://gnu-octave.github.io/packages/>.


## Quick info

- A package entry in the "Octave Packages" index is managed by a single
  [YAML](https://en.wikipedia.org/wiki/YAML) file.
  [See below `packages/pkg-example.yaml`](#example-package-entry),
  for an example package called "pkg-example".

- Adding or updating your package is done by a
  [**pull request**](https://docs.github.com/en/github/getting-started-with-github/github-glossary#pull-request).
  The pull request is reviewed
  [automatically by TravisCI](https://travis-ci.com/github/gnu-octave/packages/)
  and has to be approved and merged manually by a member of the
  [GitHub "gnu-octave" organization](https://github.com/orgs/gnu-octave/people).

  > If the automatic TravisCI review fails,
  > please [create an issue](https://github.com/gnu-octave/packages/issues)
  > to resolve the problem.

  See below for more information on automatic reviews.

- If your package does not follow the
  [Octave package format](https://octave.org/doc/v6.2.0/Creating-Packages.html)
  it cannot be installed automatically by the Octave
  [`pkg`](https://octave.org/doc/v6.2.0/Installing-and-Removing-Packages.html)-tool.
  In this case,
  please provide and link custom installation instructions to help your users.

  For a minimal example how to organize **Octave/C/C++/FORTRAN code**
  in the Octave package format,
  see <https://github.com/gnu-octave/pkg-example>.

## Add your package

- Copy the [example package entry](#example-package-entry) below
  and adapt it to your package.

- Create file `packages/<my package>.yaml` with the name of your package in the
  [packages](https://github.com/gnu-octave/packages/tree/master/packages)
  subdirectory.

  To do this, either use the "easy" way by following the
  [GitHub guide how to create a new file](https://docs.github.com/en/github/managing-files-in-a-repository/creating-new-files)
  ...

  ... or for experts:
  - fork <https://github.com/gnu-octave/packages>
  - clone your fork `https://github.com/<my username>/packages`
  - add `packages/<my package>.yaml`
  - commit and push the changes to your fork
  - finally [create a pull request](https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request).


## Update your package

- For example after a new release of your package you can update the index
  entry by editing the file `packages/<my package>.yaml` with the name of your
  package in the
  [packages](https://github.com/gnu-octave/packages/tree/master/packages)
  subdirectory.

  To do this, either use the "easy" way by following the
  [GitHub guide how to edit files](https://docs.github.com/en/github/managing-files-in-a-repository/editing-files-in-your-repository)
  and the
  [GitHub guide how to edit files in other repositories](https://docs.github.com/en/github/managing-files-in-a-repository/editing-files-in-another-users-repository)
  ...

  ... or expert users can work in a fork as described above.


## Example package entry

An example package entry
[`packages/pkg-example.yaml`](https://github.com/gnu-octave/packages/blob/master/packages/pkg-example.yaml)
(see [output](https://gnu-octave.github.io/packages/pkg-example)):

```yaml
---
layout: "package"
permalink: "pkg-example"
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
- id: "1.1.0"
  date: "2021-04-06"
  sha256: "bff441755f0d68596f2efd027fe637b5b6c52b722ffd6255bdb8a5f34ab4ef2a"
  url: "https://github.com/gnu-octave/pkg-example/archive/1.1.0.tar.gz"
  depends:
  - "octave (>= 4.0.0)"
  - "pkg"
- id: "1.0.0"
  date: "2020-09-02"
  sha256: "6b7e4b6bef5a681cb8026af55c401cee139b088480f0da60143e02ec8880cb51"
  url: "https://github.com/gnu-octave/pkg-example/archive/1.0.0.tar.gz"
  depends:
  - "octave (>= 4.0.0)"
  - "pkg"
- id: "dev"
  date:
  sha256:
  url: "https://github.com/gnu-octave/pkg-example/archive/master.zip"
  depends:
  - "octave (>= 5.2.0)"
  - "pkg"
---
```


## Details

### General specifications

- For technical reasons, the first and last line `---` of the file are
  fixed and may not be altered.

- Indent by 2 spaces (no tabs) and leave one space after colon `:`.

- All strings must be enclosed with double quotes `"`.
  `description` is an exception using a
  [block style string](https://yaml.org/spec/1.2/spec.html#Block)
  marked by `>-`.  The `description` string is `>` folded (no literal line
  breaks) and `-` chopped by the final newline.


### Individual field explanations

- `layout`: fixed string `"package"` for technical reasons.

- `permalink`: string with the name of the package.
  **Must** match the file name.

- `description`: see example above.

- `icon`: URL string to a publicly accessible image.  It will be displayed with
  `50px` width in the [package index](https://gnu-octave.github.io/packages/)
  and with `150px` with in the
  [individual package page](https://gnu-octave.github.io/packages/packages/pkg-example).

- `links`: list containing three fields.

  - `icon`: any [free FontAwesome](tawesome.com/icons?d=gallery&p=2&m=free)
    class string is permitted.  The icon is part of the hyperlink.

  - `label`: string of the hyperlink.

  - `url`: string of the hyperlink.

  You are free to choose any links in any order describing your package best.
  However, it has proved useful to give some basic information,
  as seen in the example above:

  - Link to your **license** or copyright information.
    For the label use an [SPDX string](https://spdx.org/licenses/),
    e.g. "GPL-3.0-or-later".

  - Link to release **news**.

  - Link to your development **repository**.

  - Link to your **package documentation** or homepage.

  - Link to **report a problem**.

- `maintainers`: list containing two fields.

  - `name`: maintainer name string.

  - `contact`: email address, homepage, phone number, ...
    If blank, <https://octave.discourse.group/> is displayed.

- `versions`: list containing five fields.

  > **Note:** The first version in this list is regarded as recommended for
  > installation.  Avoid listing an unstable development version at the first
  > position.  It is recommended, not necessary, to sort your releases from
  > the newest (top) to the oldest (bottom).

  - `id`: unique identifier string for this version, e.g. `"1.0.1"`, `"dev"`,
    ...

  - `date`: date string in the format `"YYYY-MM-DD"` or blank if a date does
    not apply for the release type.

  - `sha256`: [hash string](https://en.wikipedia.org/wiki/SHA-2) to verify
    integrity of your package archive or blank if integrity validation is not
    applicable.

    > **Tip:** The hash string can be obtained on many systems by the
    > `sha256sum` command:
    > ```
    > # sha256sum pkg-example-1.0.0.tar.gz
    >
    > 6b7e4b6bef5a681cb8026af55c401cee139b088480f0da60143e02ec8880cb51  pkg-example-1.0.0.tar.gz
    > ```
    > or using Octave
    > ```
    > >> urlwrite ("https://github.com/gnu-octave/pkg-example/archive/1.0.0.tar.gz", "pkg-example-1.0.0.tar.gz");
    > >> hash ("sha256", fileread ("pkg-example-1.0.0.tar.gz"))
    > ans = 6b7e4b6bef5a681cb8026af55c401cee139b088480f0da60143e02ec8880cb51
    > ```

  - `url`: URL string of the release archive (tarball or zip file).

    > **Tip:** For package development it can be handy to use the automatic
    > archive generation feature of many source code hosting services, such as
    > GitHub, GitLab, ...
    >
    > See the *example package entry* above for installing the current "master"
    > branch of the package development repository without creating a release.

  - `depends`: list of dependency strings.

    A dependency string looks like `"pkg"` or `"octave (>= 5.2.0)"`.

    > The dependency "pkg" with any or no version marks this package as
    > installable by the Octave `pkg`-tool.

    A dependency starts with the name (e.g. "pkg" or "octave"), optionally
    followed by the version in round brackets (parentheses) separated by a
    single space.  The optional version starts with an operator (e.g. `>=`)
    separated by a space to the dependent version `5.2.0`.

    Permitted names are "pkg", "octave", and any other package.

    > **Note:** Refrain from adding system libraries here, for example.
    > The used package tool might not be able to resolve the dependency
    > and makes this package "uninstallable".

    Permitted operators are documented in the
    [Octave manual](https://octave.org/doc/v6.2.0/The-DESCRIPTION-File.html)
    "DESCRIPTION"-file "Depends" section.


## Automatic reviews

Automatic reviews are performed by
[TravisCI](https://travis-ci.com/github/gnu-octave/packages/)
running the following scripts on a pull request:

- `bash` [`./assets/ci/run_yamllint.sh`](https://github.com/gnu-octave/packages/blob/master/assets/ci/run_yamllint.sh)
- `bash` [`./assets/ci/run_bundle.sh`](https://github.com/gnu-octave/packages/blob/master/assets/ci/run_bundle.sh)
- `docker run -it --volume="$(pwd):/home/packages:rw" gnuoctave/octave:6.2.0 octave --eval "run /home/packages`[`/assets/ci/run_octave.m`](https://github.com/gnu-octave/packages/blob/master/assets/ci/run_octave.m)`"`

On Linux systems,
you can run these test before a pull request to avoid failures
or to resolve issues on your local machine.
