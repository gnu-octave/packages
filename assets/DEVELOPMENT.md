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

This defines the struct array `__pkg__` in your current scope with the field
`index` (in the following example we only display three items `1:3` for
brevity):

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

That is it.  The "magic" is done by including literal Octave code inside HTML
comments within the website.

```
<!--PKG
__pkg__.index(1,:) = {"arduino", "Allow communication to a programmed arduino board to control its hardware."};

__pkg__.index(2,:) = {"audio", "Audio and MIDI Toolbox for GNU Octave."};

__pkg__.index(3,:) = {"bim", "Solving Diffusion Advection Reaction (DAR) Partial Differential Equations."};

  ...

-->
```

This strategy avoids error prone parsing HTML files.


### Read package details

Similar to the package index, you can obtain more detailed information about
individual packages.  For example for the `pkg-example` package:

```
data = urlread ("https://gnu-octave.github.io/pkg-index/package/pkg-example");
data = regexp (data, "<!--PKG(.*)-->", "tokens"){1}{1};
eval (data);
```
