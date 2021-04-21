---
layout: null
---
<pre>
{%- capture _ -%}{%- increment j -%}{%- endcapture -%}
{%- for pkg in site.pages -%}
{% if pkg.layout == "package" %}
{%- assign pkg_name = pkg.name | remove: ".yaml" -%}
__pkg__.("{{ pkg_name }}").name = "{{ pkg.permalink }}";
__pkg__.("{{ pkg_name }}").description = "{{ pkg.description | newline_to_br | strip_newlines | replace: '<br />', ' ' | strip_html | strip | escape }}";
__pkg__.("{{ pkg_name }}").icon = "{{ pkg.icon }}";
{% for l in pkg.links %}
{%- assign i = forloop.index -%}
__pkg__.("{{ pkg_name }}").links({{ i }}).icon = "{{ l.icon }}";
__pkg__.("{{ pkg_name }}").links({{ i }}).label = "{{ l.label | escape }}";
__pkg__.("{{ pkg_name }}").links({{ i }}).url = "{{ l.url }}";
{% endfor %}
{% for m in pkg.maintainers %}
{%- assign i = forloop.index -%}
__pkg__.("{{ pkg_name }}").maintainers({{ i }}).name = "{{ m.name | escape }}";
__pkg__.("{{ pkg_name }}").maintainers({{ i }}).contact = "{{ m.contact | escape }}";
{% endfor %}
{% for v in pkg.versions %}
{%- assign i = forloop.index -%}
__pkg__.("{{ pkg_name }}").versions({{ i }}).id = "{{ v.id }}";
__pkg__.("{{ pkg_name }}").versions({{ i }}).date = "{{ v.date }}";
__pkg__.("{{ pkg_name }}").versions({{ i }}).sha256 = "{{ v.sha256 }}";
__pkg__.("{{ pkg_name }}").versions({{ i }}).url = "{{ v.url }}";
{% for dep in v.depends %}
{%- assign j = forloop.index -%}
__pkg__.("{{ pkg_name }}").versions({{ i }}).depends({{ j }}).name = "{{ dep }}";
{% endfor %}
{% endfor %}
{% endif %}
{%- endfor -%}
%</pre>
