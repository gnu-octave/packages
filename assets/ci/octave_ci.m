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
    step_disp_h1 (["Run: pkg install   ", pkg_name_version]);
    pkg ("install",  __pkg__.(package_name).versions(1).url);
    step_disp_h2 ("done.");
    step_disp_h1 (["Run: pkg load      ", pkg_name_version]);
    pkg ("load", package_name);
    step_disp_h2 ("done.");
    step_disp_h1 (["Run: pkg unload    ", pkg_name_version]);
    pkg ("unload", package_name);
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
