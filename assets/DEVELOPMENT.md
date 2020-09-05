# GNU Octave - Package extensions index

**Development guide**

## Quick info

1. Your package management tool must implement a single routine only:

   ```
   function __pkg__ = pkg_index_resolve (__pkg__, url)
     data = urlread (url);
     data = regexp (data, "<!--PKG(.*)-->", "tokens"){1}{1};
     eval (data);
   endfunction
   ```

2. Read the **package index** with:

   ```
   url = "https://gnu-octave.github.io/pkg-index/";
   __pkg__ = pkg_index_resolve (struct (), url);
   ```

3. Read **package details** with:

   ```
   __pkg__ = pkg_index_resolve (__pkg__, [url, "package/pkg-example"]);
   ```


## Detailed information for writing a package management tool

This package index is build from the perspective of a package management tool
written in the GNU Octave language.

### Read the package index

Using the routine `pkg_index_resolve()` as describe in the quick info above,
to read the package index (all available packages with a short description)
from within Octave, run:

```
url = "https://gnu-octave.github.io/pkg-index/";
__pkg__ = pkg_index_resolve (struct (), url);
```

This routine returns a struct `__pkg__` with the field `index`.
In the following example we only display three items `1:3` for brevity:

```
>> __pkg__.index(1:3,1)
ans =
{
  [1,1] = arduino
  [2,1] = audio
  [3,1] = bim
}
```

```
>> __pkg__.index(1:3,2)
ans =
{
  [1,1] = Allow communication to a programmed arduino board to control its hardware.
  [2,1] = Audio and MIDI Toolbox for GNU Octave.
  [3,1] = Solving Diffusion Advection Reaction (DAR) Partial Differential Equations.
}
```

That is it.  The "magic" is done by embedding literal Octave code inside HTML
comments within the website.

```
<!--PKG
__pkg__.index(1,:) = {"arduino", "Allow communication to a programmed arduino board to control its hardware."};

__pkg__.index(2,:) = {"audio", "Audio and MIDI Toolbox for GNU Octave."};

__pkg__.index(3,:) = {"bim", "Solving Diffusion Advection Reaction (DAR) Partial Differential Equations."};

  ...

-->
```

This strategy avoids error prone parsing of HTML files.  A layout change does
not mess up the parsing of the package management tool.


### Read package details

Similar to the package index, you can obtain more detailed information about
individual packages.  For example the following code obtains the details of
the `pkg-example` package.

```
url = "https://gnu-octave.github.io/pkg-index/";
__pkg__ = pkg_index_resolve (__pkg__, [url, "package/pkg-example"]);
```

The struct `__pkg__` gets extended by a field named by the package name.
For this reason we use a Octave's named indexing with the package name as
string in brackets.  This avoid invalid identifiers.

```
>> __pkg__.("pkg-example")
ans =

  scalar structure containing the fields:

    description = Example package to demonstrate the creation process of an Octave package. Keep this description brief.  Describe the major features in the first two lines (160 characters). Multiple lines are allowed.Each line may have maximal 80 characters. Exceptions are URLs.  Paragraphs, blank lines, and line breaks are ignored and replaced by spaces.
    homepage = https://github.com/gnu-octave/pkg-example
    icon = https://raw.githubusercontent.com/gnu-octave/pkg-example/master/doc/icon.png
    license = GPL-3.0-or-later
    maintainers =

      1x2 struct array containing the fields:

        name
        contact

    versions =

      1x2 struct array containing the fields:

        id
        date
        sha256
        url
        depends
```

```
>> __pkg__.("pkg-example").versions(1)
ans =

  scalar structure containing the fields:

    id = 1.0.0
    date = 2020-09-02
    sha256 = 6b7e4b6bef5a681cb8026af55c401cee139b088480f0da60143e02ec8880cb51
    url = https://github.com/gnu-octave/pkg-example/archive/1.0.0.tar.gz
    depends =

      scalar structure containing the fields:

        name = octave
        min = 4.2.0
        max =
```


### Compatibility with Octave's `pkg` tool

In case you want to stay compatible with
[Octave's builtin package management tool `pkg`](https://www.octave.org/doc/v5.2.0/XREFpkg.html)
you should care about the following default settings:

- `pkg prefix` (default: `~/octave`): directory new packages are installed to.
- `pkg local_list` (default: `~/.octave_packages`): file listing installed
  local packages.  The file is simply created by saving an array of structs
  using Octave's default `save` command.
  When loading the content of this file (`load ~/.octave_packages`) an entry
  looks like this:

  ```
  >> local_packages (1)
  ans =
  {
    [1,1] =

      scalar structure containing the fields:

        name = pkg-example
        version = 1.0.0
        date = 2020-09-02
        author = Kai T. Ohlhus <k.ohlhus@gmail.com>
        maintainer = Kai T. Ohlhus <k.ohlhus@gmail.com>
        title = Minimal example package to demonstrate the Octave package extensions.
        description = Minimal example package to demonstrate the Octave package  extensions.  It shows how to organize Octave, C/C++, and FORTRAN code within  a package and to properly compile it.
        depends =
        dir = /home/siko1056/.local/share/octave/5.2.0/pkg-example-1.0.0
        archprefix = /home/siko1056/.local/share/octave/5.2.0/pkg-example-1.0.0
        loaded = 0

  }
  ```

- `pkg global_list` (default:
  [`OCTAVE_HOME ()`](https://www.octave.org/doc/v5.2.0/XREFOCTAVE_005fHOME.html)
  `/share/octave/octave_packages`):
  analogous list for global packages.


## Developing the websites of package extensions index

Two important links first:

1. Development repository: <https://github.com/gnu-octave/pkg-index>
2. Deployment URL: <https://gnu-octave.github.io/pkg-index/>

In this section some hints for developing this index from the server site are
given.

- The whole index is a **static website** generated by
  [bundler](https://bundler.io/) and [Jekyll](https://jekyllrb.com/)
  and hosted on
  [GitHub pages](https://pages.github.com/).

- There is **no limitation** to host the generated static pages on an
  **arbitrary webserver**.

- Build the static websites with bundler/Jekyll
  ```
  git clone https://github.com/gnu-octave/pkg-index
  cd pkg-index
  bundle install
  bundle exec jekyll build
  ```
  and copy the content of the generated `_site` directory to the webserver of
  your choice.

- Basically, there are two layouts.  One for the package index
  `_layouts/package_index.html` and one for the individual packages pages
  `_layouts/package.html`.

- The package index page uses the JavaScript framework
  [DataTables](https://datatables.net/) for a dynamic search feature.
  If no JavaScript is available, a static HTML table is displayed.

- The individual package pages are generated by filling the layout with the
  metadata given in YAML format.
