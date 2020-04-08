# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import chromium with context %}

{%- if 'config' in chromium and chromium.config %}
        {%- set sls_package_clean = tplroot ~ '.package.clean' %}

include:
  - {{ sls_package_clean }}

chromium-config-clean-file-absent:
  file.absent:
    - name: {{ chromium.environ_file }}
    - require:
      - sls: {{ sls_package_clean }}
