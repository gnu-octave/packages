---
layout: null
permalink: /packages/forge-download
---
<pre>
{%- for pkg in site.pages -%}
{%- if pkg.layout == "package" -%}
{% assign pkg_name = pkg.name | remove: ".yaml" %}
{{ pkg_name }}-{{ pkg.versions[0].id }}.tar.gz,{{ pkg.versions[0].url }}
{%- endif -%}
{%- endfor -%}
%</pre>
