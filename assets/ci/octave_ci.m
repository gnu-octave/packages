## Helper function to test the package installation from a local package index.
##
##  `package_name`   the package to test
##  `pkg_index_file` the package index file
##
## The "genuine" package index file is located online
##
##    https://gnu-octave.github.io/packages/packages/index.html
##
## Read <https://github.com/gnu-octave/packages/blob/main/doc/development.md>
## for how to create a local package index.
##
## Note: This function is used by GitHub Actions for CI.
##       For local package tests, run "pkg test ...".
##

function octave_ci (package_name, pkg_index_file)

  if (nargin < 1)
    step_disp_h2 ("STOP.  No package provided.");
    return;
  endif

  ## Resolve locally build package index.
  step_disp_h1 ("Resolve locally build package index");
  if (exist (pkg_index_file, "file") != 2)
    step_disp_h2 (["STOP.  Cannot find '", pkg_index_file, "'."]);
    return;
  endif
  __pkg__ = package_index_local_resolve (pkg_index_file);
  step_disp_h2 ("done.");

  ## Try to install and test the default (first) version of the changed
  ## packages.
  try
    pkg_name_version = [package_name, "@", ...
      __pkg__.(package_name).versions(1).id];

    ## Check if package can be installed by "pkg", otherwise skip.
    pkg_installable = false;
    dependencies = {__pkg__.(package_name).versions(1).depends.name};
    for i = 1:length (dependencies)
      if (strcmp (strsplit (dependencies{i}){1}, "pkg"))
        pkg_installable = true;
        break;
      endif
    endfor
    if (! pkg_installable)
      step_disp_h2 (["STOP.  '", pkg_name_version, "', no 'pkg' dependency."]);
      return;
    endif

    ## Test basic package installation.
    mkdir ("~/octave");  # Avoids pkg warning.
    cd (tempdir ());

    step_disp_h1 ("Resolve package dependencies");
    [ubuntu2004, pkgs] = resolve_deps (__pkg__, {package_name});
    step_disp_h2 ("done.");

    if (! isempty (ubuntu2004))
      step_disp_h1 ("Install Ubuntu 20.04 dependencies");
      system ("sudo apt-get -qq update");
      system (["sudo apt-get -qq install --yes ", strjoin(ubuntu2004)]);
      step_disp_h2 ("done.");
    endif

    ## Install package dependencies and "doctest" package.
    pkgs = [pkgs, {"doctest"}];
    for i = length (pkgs):-1:1
      pkg_dep_name = pkgs{i};
      pkg_dep_name_version = [pkg_dep_name, "@", ...
        __pkg__.(pkg_dep_name).versions(1).id];
      step_disp_h1 (["Install dependency:  ", pkg_dep_name_version]);
      pkg_install_sha256_check (__pkg__.(pkg_dep_name).versions(1));
      step_disp_h2 ("done.");
    endfor

    step_disp_h1 (["Run: pkg install   ", pkg_name_version]);
    pkg_install_sha256_check (__pkg__.(package_name).versions(1));
    step_disp_h2 ("done.");

    step_disp_h1 (["Run: pkg load      ", pkg_name_version]);
    pkg ("load", package_name);
    step_disp_h2 ("done.");

    step_disp_h1 (["Run: pkg unload    ", pkg_name_version]);
    pkg ("unload", package_name);
    step_disp_h2 ("done.");

    step_disp_h1 (["Run: doctest       ", pkg_name_version]);
    pkg ("load", "doctest");
    doctest_dir = pkg ("list", package_name);
    doctest_dir = doctest_dir{1}.dir;
    doctest (doctest_dir);
    step_disp_h2 ("done.");

    step_disp_h1 (["Run: pkg test      ", pkg_name_version]);
    pkg ("test", package_name);
    step_disp_h2 ("done.");

    step_disp_h1 (["Run: pkg uninstall ", pkg_name_version]);
    pkg ("uninstall", package_name);
    step_disp_h2 ("done.");

    step_disp_h1 ("Show: fntests.log");
    type (fullfile (tempdir (), "fntests.log"))

    step_disp_h1 ("FINISHING");
  catch e
    ## In case of error try to get as much information as possible.
    ##
    ## Note that the installation is likely to fail for packages with
    ## dependencies:
    ##
    ## Dependency resolution and installation is not supported
    ## in old pkg versions.

    disp (e);

    step_disp_h2 (["Run: pkg install -verbose ", pkg_name_version]);
    pkg ("install", "-verbose",  __pkg__.(package_name).versions(1).url);
  end

endfunction


function __pkg__ = package_index_local_resolve (pkg_index_file)
  # Normally
  # data = urlread ("https://gnu-octave.github.io/packages/packages/")(6:end);
  data = fileread (pkg_index_file)(6:end);
  data = strrep (data, "&gt;",  ">");
  data = strrep (data, "&lt;",  "<");
  data = strrep (data, "&amp;", "&");
  data = strrep (data, "&#39;", "'");
  eval (data);
endfunction


function step_disp_h1 (str)
  persistent i = 1;
  disp (" ");
  disp ("--------------------------------------------------");
  printf ("--- Step %2d: %s\n", i++, str);
  disp ("--------------------------------------------------");
  disp (" ");
endfunction


function step_disp_h2 (str)
  printf ("\n    %s\n\n", str);
endfunction


function pkg_install_sha256_check (pkg_version)
  cd (tempdir ());
  [~, pkg_file, pkg_ext] = fileparts (pkg_version.url);
  pkg_file = [pkg_file, pkg_ext];
  urlwrite (pkg_version.url, pkg_file);
  sha256_sum = hash ("sha256", fileread (pkg_file));
  if (! strcmp (sha256_sum, pkg_version.sha256))
    error (["Package checksum error:\n", ...
      "\n\tFile: %s", ...
      "\n\tExpected: '%s'", ...
      "\n\tBut got:  '%s'\n"], pkg_file, pkg_version.sha256, sha256_sum);
  else
    disp (["sha256 checksum ok: '", sha256_sum, "'"]);
  endif
  pkg ("install",  pkg_file);
endfunction


function [ubuntu2004, pkgs] = resolve_deps (__pkg__, stack);
## Simple resolver function.
##
## Only considers the newest version of a package.
##
## Returned `pkgs` must be installed from end to 1.
##

  pkgs = {};
  ubuntu2004 = {};
  p = __pkg__.(stack{end}).versions(1);

  if (isfield (p, "depends"))
    pkgs = {p.depends.name};
    pkgs = cellfun (@strtok, pkgs, "UniformOutput", false);
    pkgs(strcmp (pkgs, "octave")) = [];
    pkgs(strcmp (pkgs, "pkg")) = [];

    ## Recursively find further dependencies.
    for i = 1:length (pkgs)
      if (any (strcmp (pkgs{i}, stack)))
        error ("resolve_deps: circular dependency detected.");
      endif
      [new_ubuntu2004, new_pkgs] = resolve_deps (__pkg__, [stack, pkgs(i)]);
      ubuntu2004 = [ubuntu2004, new_ubuntu2004];
      pkgs = [pkgs, new_pkgs];
    endfor
  endif

  if (isfield (p, "ubuntu2004"))
    new_ubuntu2004 = {p.ubuntu2004.name};
    for i = 1:length (new_ubuntu2004)
      ## Ubuntu/Debian package name must consist only of lower case letters
      ## (a-z), digits (0-9), plus (+) and minus (-) signs, and periods (.).
      m = regexp (new_ubuntu2004{i}, '[a-z0-9\+\-\.]*', "match");
      if (length (m) ~= 1)
        error ("resolve_deps: invalid Ubuntu 20.04 package %s.", ...
          new_ubuntu2004{i});
      endif
    endfor
    ubuntu2004 = [ubuntu2004, new_ubuntu2004];
  endif

endfunction
