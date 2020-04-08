# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import chromium with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

{%- if chromium.environ or chromium.config.path %}

    {%- if chromium.pkg.use_upstream_source %}
        {%- set sls_package_install = tplroot ~ '.source.install' %}
    {%- elif chromium.pkg.use_upstream_archive %}
        {%- set sls_package_install = tplroot ~ '.archive.install' %}
    {%- else %}
        {%- set sls_package_install = tplroot ~ '.package.install' %}
    {%- endif %}
include:
  - {{ sls_package_install }}

chromium-config-file-managed-environ_file:
  file.managed:
    - name: {{ chromium.environ_file }}
    - source: {{ files_switch(['environ.sh.jinja'],
                              lookup='chromium-config-file-managed-environ_file'
                 )
              }}
    - mode: 640
    - user: {{ chromium.rootuser }}
    - group: {{ chromium.rootgroup }}
    - makedirs: True
    - template: jinja
    - context:
        path: {{ chromium.config.path|json }}
        environ: {{ chromium.environ|json }}
    - require:
      - sls: {{ sls_package_install }}

{%- endif %}
