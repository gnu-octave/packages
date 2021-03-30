function run_octave ()
  ## Set package paths Octave version specific
  step_disp_h1 ("Set package install directory");
  tmp = "/home/packages";
  tmp = pkg ("prefix", tmp, tmp);
  pkg ("local_list", [tmp, "/.octave_packages"]);
  disp (["    dir: ", tmp, "/.octave_packages"]);
  step_disp_h2 ("done.");

  ## Resolve locally build package index from (assets/ci/run_bundle.sh).
  step_disp_h1 ("Resolve locally build package index");
  __pkg__ = package_index_local_resolve ();
  step_disp_h2 ("done.");

  ## Try to install and test the default (first) version of the changed
  ## packages.
  step_disp_h1 ("Install and test changed packages");
  pList = get_changed_packages ();
  printf ("    %d package(s) found: %s\n", length (pList), ...
    strjoin (pList, " "));
  for p = pList
    try
      pkg_name_version = [p{1}, "@", __pkg__.(p{1}).versions(1).id];
      step_disp_h2 (["Run: pkg install   ", pkg_name_version]);
      pkg ("install",  __pkg__.(p{1}).versions(1).url);
      step_disp_h2 ("done.");
      step_disp_h2 (["Run: pkg load      ", pkg_name_version]);
      pkg ("load", p{1});
      step_disp_h2 ("done.");
      step_disp_h2 (["Run: pkg unload    ", pkg_name_version]);
      pkg ("unload", p{1});
      step_disp_h2 ("done.");
      step_disp_h2 (["Run: pkg test      ", pkg_name_version]);
      pkg ("test", p{1});
      step_disp_h2 ("done.");
      step_disp_h2 (["Run: pkg uninstall ", pkg_name_version]);
      pkg ("uninstall", p{1});
      step_disp_h2 ("done.");
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
      pkg ("install", "-verbose",  __pkg__.(p{1}).versions(1).url);
    end
  endfor
endfunction


function changed_packages = get_changed_packages ()
  ## Return a cell array of strings of changed "package/*" files (packages)
  ## from the last git commit.
  changed_packages = cell(0,1);
  git_command = "git --no-pager diff --name-only HEAD HEAD~1";
  [~, output] = system (git_command);
  output = (strsplit (output))(1:end-1);
  for i = 1:length (output)
    [directory, name, ext] = fileparts (output{i});
    if (strcmp (directory, "package") && ! strcmp (name, "index"))
      changed_packages{end + 1, 1} = name;
    endif
  endfor
endfunction


function __pkg__ = package_index_local_resolve ()
  # Normally
  # data = urlread ("https://gnu-octave.github.io/packages/package/")(6:end);
  data = fileread ("../../test/package/index.html")(6:end);
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
endfunction

function step_disp_h2 (str)
  disp (" ");
  printf ("    %s\n", str);
  disp (" ");
endfunction
