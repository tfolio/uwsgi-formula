{% from "uwsgi/map.jinja" import uwsgi with context -%}

uwsgi:
  pkg:
    - installed
    - name: {{ uwsgi.pkg }}
  service:
    - running
    - name: {{ uwsgi.service }}
    - enable: True

{% macro uwsgi_plugin(name) -%}
{% if salt['pillar.get']('uwsgi:plugins:{}'.format(name), false) -%}
uwsgi-plugin-{{ name }}:
  pkg:
    - installed
    - name: {{ uwsgi.plugin_pkg.get(name) }}
    - require_in:
      service: uwsgi
{% endif -%}
{% endmacro -%}

{% set plugin_list = [
    'greenlet',
    'php',
    'psgi',
    'python',
    'python3',
] -%}

{% for plugin_name in plugin_list -%}
{{ uwsgi_plugin(plugin_name) }}
{% endfor -%}
