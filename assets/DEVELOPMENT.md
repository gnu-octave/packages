# GNU Octave - Package extensions index

**Development guide**

## Get package information using Octave

This package index is build from the perspective of a package management tool
written in the GNU Octave language.

### Read the package index

To read the package index (all available packages with a short description)
from within Octave, run:

```
data = urlread ("https://gnu-octave.github.io/pkg-index/");
data = regexp (data, "<!--PKG(.*)-->", "tokens"){1}{1};
eval (data);
```

This defines in your current scope a struct `__pkg__` with the field `index`.
In the following example we only display three items `1:3` for brevity:

```
>> __pkg__.index(1:3,1)
ans =
{
  [1,1] = arduino
  [2,1] = audio
  [3,1] = bim
}

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
individual packages.  For example for the `pkg-example` package:

```
data = urlread ("https://gnu-octave.github.io/pkg-index/package/pkg-example");
data = regexp (data, "<!--PKG(.*)-->", "tokens"){1}{1};
eval (data);
```

This defines another field within the `__pkg__` struct:

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

Note, that we use a special named indexing with the package name as string in
brackets.
