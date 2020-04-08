# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import chromium with context %}

    {%- if grains.os_family == 'MacOS' %}

chromium-package-remove-cmd-run-cask:
  cmd.run:
    - name: brew cask remove {{ chromium.pkg.name }}
    - runas: {{ chromium.rootuser }}
    - onlyif: test -x /usr/local/bin/brew

    {%- elif grains.kernel|lower == 'linux' %}

chromium-package-remove-pkg-removed:
  pkg.removed:
    - name: {{ chromium.pkg.name }}
    - reload_modules: true

    {%- endif %}
