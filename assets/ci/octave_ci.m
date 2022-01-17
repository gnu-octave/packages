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
    step_warning ("STOP.  No package provided.");
    return;
  endif

  ## Resolve locally build package index.
  step_group_start ("Resolve locally build package index");
  if (exist (pkg_index_file, "file") != 2)
    step_group_end (["STOP.  Cannot find '", pkg_index_file, "'."]);
    exit (1);
  endif
  __pkg__ = package_index_local_resolve (pkg_index_file);
  step_group_end ("done.");

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
    step_warning (["STOP.  '", pkg_name_version, "', no 'pkg' dependency."]);
    return;
  endif

  ## Test basic package installation.
  mkdir ("~/octave");  # Avoids pkg warning.
  test_dir = tempdir ();
  cd (test_dir);

  step_group_start ("Resolve package dependencies");
  [ubuntu2004, pkgs] = resolve_deps (__pkg__, {package_name});
  step_group_end ("done.");

  if (! isempty (ubuntu2004))
    step_group_start ("Install Ubuntu 20.04 dependencies");
    [~,~] = system ("sudo apt-get update");
    [~,~] = system (["sudo apt-get install --yes ", strjoin(ubuntu2004)]);
    step_group_end ("done.");
  endif

  ## Install package dependencies and "doctest" package.
  pkgs = [pkgs, {"doctest"}];
  for i = length (pkgs):-1:1
    pkg_dep_name = pkgs{i};
    pkg_dep_name_version = [pkg_dep_name, "@", ...
      __pkg__.(pkg_dep_name).versions(1).id];
    step_group_start (["Install dependency:  ", pkg_dep_name_version]);
    pkg_install_sha256_check (__pkg__.(pkg_dep_name).versions(1), test_dir);
    step_group_end ("done.");
  endfor

  ## Try to install and test the default (first) version of the changed
  ## packages.
  try
    step_group_start (["Run: pkg install   ", pkg_name_version]);
    pkg_install_sha256_check (__pkg__.(package_name).versions(1), test_dir);
    step_group_end ("done.");
  catch e
    ## In case of install error, try to get as much information as possible.
    ##
    ## Note that the installation is likely to fail for packages with
    ## "exotic" dependencies.

    step_group_start (["ERROR: pkg install -verbose ", pkg_name_version]);
    pkg ("install", "-verbose",  __pkg__.(package_name).versions(1).url);
    step_group_end ("done.");

    exit (1);  # Return test failed.
  end

  step_group_start (["Run: pkg load      ", pkg_name_version]);
  pkg ("load", package_name);
  step_group_end ("done.");

  step_group_start (["Run: pkg unload    ", pkg_name_version]);
  pkg ("unload", package_name);
  step_group_end ("done.");

  step_group_start (["Run: doctest       ", pkg_name_version]);
  pkg ("load", "doctest");
  doctest_dir = pkg ("list", package_name);
  doctest_dir = doctest_dir{1}.dir;
  try
    doctest (doctest_dir);
  catch e
    disp (e);

    ## Ingore further doctest, not mandatory.
  end
  step_group_end ("done.");

  cd (test_dir);  # To this directory "fntests.log" is written.

  step_group_start (["Run: pkg test      ", pkg_name_version]);
  pkg ("test", package_name);
  step_group_end ("done.");

  step_group_start (["Run: pkg uninstall ", pkg_name_version]);
  pkg ("uninstall", package_name);
  step_group_end ("done.");

  step_group_start ("Show: fntests.log");
  type (fullfile (test_dir, "fntests.log"));
  step_group_end ("done.");

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


function step_warning (str)
  printf ("::warning::%s\n", str);
endfunction


function step_group_start (str)
  printf ("::group::%s\n", str);
endfunction


function step_group_end (str)
  printf ("\n    %s\n\n", str);
  disp ("::endgroup::");
endfunction


function pkg_install_sha256_check (pkg_version, test_dir)
  cd (test_dir);
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
  pkg ("install", pkg_file);
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
      if ((length (m) ~= 1) || ~strcmp (m{1}, new_ubuntu2004{i}))
        error ("resolve_deps: invalid Ubuntu 20.04 package %s.", ...
          new_ubuntu2004{i});
      endif
    endfor
    ubuntu2004 = [ubuntu2004, new_ubuntu2004];
  endif

endfunction
