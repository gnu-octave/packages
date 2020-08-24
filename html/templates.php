<?php

function print_html_header ($title) {
  echo '<!DOCTYPE html>
<html lang="en">
  <head>
    <link rel="stylesheet" href="html/style.css" type="text/css">
    <title>' . $title . '</title>
  </head>
  <body>
  <h1>' . $title . '</h1>';
}

function print_html_footer () {
  echo '  </body>
</html>';
}

function print_html_packages ($pkg_name_pattern, $pkg_registry_data) {
  if (strcmp ($pkg_name_pattern, '*') !== 0) {
    echo '<h2>List of packages containing "' . $pkg_name_pattern . '"</h2>';
  } else {
    echo '<h2>List of all packages</h2>';
  }
  echo 'Sort:
  <a href="?name=' . $pkg_name_pattern . '&orderby=name-asc">A to Z</a>,
  <a href="?name=' . $pkg_name_pattern . '&orderby=name-desc">Z to A</a>,
  <a href="?name=' . $pkg_name_pattern . '&orderby=age-asc">Newest first</a>,
  <a href="?name=' . $pkg_name_pattern . '&orderby=age-desc">Oldest first</a>';
  echo '<div>';
  foreach ($pkg_registry_data as &$pkg) {
    print_html_package ($pkg);
  }
  echo '</div>';
}

function print_html_package ($pkg) {
  $pkg_latest_ver  = key ($pkg['versions'][0]);
  $pkg_latest_date = $pkg['versions'][0][$pkg_latest_ver]['date'];
  $pkg_latest_url  = $pkg['versions'][0][$pkg_latest_ver]['url'];

  echo '<div class="package">
  <img src="' . $pkg['image'] . '" alt="' . $pkg['name'] . '">
  <div>
  <h3 class="package_name" id="' . $pkg['name'] . '">
    <a class="package_name" href="' . $pkg['url'] . '">' . $pkg['name'] . '</a>
  </h3>
  <p class="package_desc">'
    . $pkg['description'] .
  '<br><br>' . $pkg_latest_ver . ' (' . $pkg_latest_date . ')
  </p>
  </div>
</div>';
}

?>
