# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import chromium with context %}

    {%- if grains.os_family == 'MacOS' %}

chromium-package-clean-cmd-run-cask:
  cmd.run:
    - name: brew cask clean {{ chromium.pkg.name }}
    - runas: {{ chromium.rootuser }}
    - onlyif: test -x /usr/local/bin/brew

    {%- elif grains.kernel|lower == 'linux' %}

chromium-package-clean-pkg-cleaned:
  pkg.cleand:
    - name: {{ chromium.pkg.name }}
    - reload_modules: true
  cmd.run:
    - name: snap remove {{ chrome.pkg.name }}
    - onlyif: test -x /usr/bin/snap || test -x /usr/local/bin/snap
    - onfail:
       - pkg: chrome-package-clean-pkg-cleaned

    {%- endif %}
