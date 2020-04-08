# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import chromium with context %}

{%- if 'config' in chromium and chromium.config %}

    {%- if chromium.pkg.use_upstream_source %}
        {%- set sls_package_clean = tplroot ~ '.source.clean' %}
    {%- elif chromium.pkg.use_upstream_archive %}
        {%- set sls_package_clean = tplroot ~ '.archive.clean' %}
    {%- else %}
        {%- set sls_package_clean = tplroot ~ '.package.clean' %}
    {%- endif %}
include:
  - {{ sls_package_clean }}

chromium-config-clean-file-absent:
  file.absent:
    - names:
      - {{ chromium.environ_file }}
    - require:
      - sls: {{ sls_package_clean }}
