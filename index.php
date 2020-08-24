<?php

ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

include 'html/templates.php';

function sort_by_age_asc ($a, $b) {
  $a_age = $a['versions'][0][key ($a['versions'][0])]['date'];
  $b_age = $b['versions'][0][key ($b['versions'][0])]['date'];
  if ($a_age == $b_age) {
      return 0;
  }
  return ($a_age < $b_age) ? 1 : -1;
}

function sort_by_age_desc ($a, $b) {
  return sort_by_age_asc  ($a, $b) * (-1);
}

// Package registry meta data
$pkg_registry_title = 'GNU Octave package extensions';
$pkg_registry_url = 'https://packages.octave.space';
$pkg_registry_yaml_file = 'packages.yaml';

// GET parameters
if (! empty($_GET['name'])) {
  $pkg_name_pattern = htmlspecialchars($_GET['name']);
} else {
  $pkg_name_pattern = '*';
}
if (! empty($_GET['orderby'])) {
  $orderby = htmlspecialchars($_GET['orderby']);
} else {
  $orderby = 'name-asc';
}

if (file_exists ($pkg_registry_yaml_file)) {
  $pkg_registry_data = yaml_parse_file ($pkg_registry_yaml_file);
  if (strcmp ($orderby, 'name-asc') == 0) {
    ksort($pkg_registry_data);
  } elseif (strcmp ($orderby, 'name-desc') == 0) {
    krsort($pkg_registry_data);
  } elseif (strcmp ($orderby, 'age-asc') == 0) {
    usort($pkg_registry_data, "sort_by_age_asc");
  } elseif (strcmp ($orderby, 'age-desc') == 0) {
    usort($pkg_registry_data, "sort_by_age_desc");
  }
  print_html_header ($pkg_registry_title);
  print_html_packages ($pkg_name_pattern, $pkg_registry_data);
  print_html_footer ();
} else {
  print ("$pkg_registry_title: could not read package data file.");
}
?>
