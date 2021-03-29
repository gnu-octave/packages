# Package contribution guidelines

This guide explains how to add a package the
[GNU Octave - Package extensions index](https://gnu-octave.github.io/packages/).


## Quick info

- Your package must follow the
  [Octave package format](https://octave.org/doc/v5.2.0/Creating-Packages.html).
  For a minimal example demonstrating **Octave/C/C++/FORTRAN code** see
  <https://github.com/gnu-octave/pkg-example>.

- A package entry in this index is managed by a single file,
  [`package/pkg-example.md`](#example-package-index-entry),
  for an example package called "pkg-example".
  The content is [Markdown](https://en.wikipedia.org/wiki/Markdown)
  embedding [YAML](https://en.wikipedia.org/wiki/YAML) data.

- Adding or updating your package is done by a
  [**pull request**](https://docs.github.com/en/github/getting-started-with-github/github-glossary#pull-request).
  The pull request is reviewed
  [automatically by TravisCI](https://travis-ci.org/github/gnu-octave/packages)
  and has to be approved and merged manually by a member of the
  [GitHub "gnu-octave" organization](https://github.com/orgs/gnu-octave/people).
  If the automatic review fails, it is less likely that your contribution will
  be accepted.  See below for more information on automatic reviews.


## Add your package

- Copy the *example package index entry* below and adapt it to your package.

- Create file `package/<my package>.md` with the name of your package in the
  [package](https://github.com/gnu-octave/packages/tree/master/package)
  subdirectory.

  To do this, either use the "easy" way by following the
  [GitHub guide how to create a new file](https://docs.github.com/en/github/managing-files-in-a-repository/creating-new-files)
  ...

  ... or for experts:
  - fork <https://github.com/gnu-octave/packages>
  - clone your fork `https://github.com/<my username>/packages`
  - add `package/<my package>.md`
  - commit and push the changes to your fork
  - finally [create a pull request](https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request).


## Update your package

- For example after a new release of your package you can update the index
  entry by editing the file `package/<my package>.md` with the name of your
  package in the
  [package](https://github.com/gnu-octave/packages/tree/master/package)
  subdirectory.

  To do this, either use the "easy" way by following the
  [GitHub guide how to edit files](https://docs.github.com/en/github/managing-files-in-a-repository/editing-files-in-your-repository)
  and the
  [GitHub guide how to edit files in other repositories](https://docs.github.com/en/github/managing-files-in-a-repository/editing-files-in-another-users-repository)
  ...

  ... or expert users can work in a fork as described above.


## Example package index entry

An example package index entry `package/pkg-example.md`
(see [output](https://gnu-octave.github.io/packages/package/pkg-example)):

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
license: "GPL-3.0-or-later"
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
  - name: "octave"
    min: "4.2.0"
    max:
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

- `description`: see example above.

- `homepage`: URL string of the package homepage.  This can be the development
  repository or some descriptive page containing documentation.

- `icon`: URL string to a publicly accessible image.  It will be displayed with
  `50px` width in the [package index](https://gnu-octave.github.io/packages/)
  and with `150px` with in the
  [individual package page](https://gnu-octave.github.io/packages/package/pkg-example).

- `license`: license identifier string, see <https://spdx.org/licenses/>.

- `maintainers`: list containing two fields.

  - `name`: name string.

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
    > See the *example package index* entry above for installing the current
    > "master" branch of the package development repository without creating
    > a release.

  - `depends`: list containing three fields.

    - `name`: identifier string for the dependency.  For example `"octave"` or
      another package in this index.

      > **Note:** Refrain from adding Linux system libraries here, for example.
      > The used package tool might not be able to resolve the dependency
      > and makes this package "uninstallable".

    - `min`: identifier string for the minimal supported version or blank if not
      applicable.

    - `max`: identifier string for the maximal supported version or blank if not
      applicable.


## Automatic reviews

Automatic reviews happen by TravisCI running the following scripts on a pull
request:

- [`assets/travis/run_yamllint.sh`](https://github.com/gnu-octave/packages/blob/master/assets/travis/run_yamllint.sh):
  lint the package file using the `yamllint` tool with
  [this configuration](https://github.com/gnu-octave/packages/blob/master/assets/travis/yamllint.yaml).
- [`assets/travis/run_on_pull_request.sh`](https://github.com/gnu-octave/packages/blob/master/assets/travis/run_on_pull_requests.sh):
  empty test, not yet implemented.  In future updates minimal installation
  checks will be performed.

You can run these test on Linux before starting a pull request to avoid
failures.
