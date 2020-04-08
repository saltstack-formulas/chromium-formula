# -*- coding: utf-8 -*-
# vim: ft=sls

  {%- if grains.os_family == 'MacOS' %}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import chromium with context %}

chromium-macos-app-install-curl:
  file.directory:
    - name: {{ chromium.dir.tmp }}
    - makedirs: True
    - clean: True
  pkg.installed:
    - name: curl
  cmd.run:
    - name: curl -Lo {{ chromium.dir.tmp }}/chromium-{{ chromium.version }} {{ chromium.pkg.macapp.source }}
    - unless: test -f {{ chromium.dir.tmp }}/chromium-{{ chromium.version }}
    - require:
      - file: chromium-macos-app-install-curl
      - pkg: chromium-macos-app-install-curl
    - retry: {{ chromium.retry_option }}

      # Check the hash sum. If check fails remove
      # the file to trigger fresh download on rerun
chromium-macos-app-install-checksum:
  module.run:
    - onlyif: {{ chromium.pkg.macapp.source_hash }}
    - name: file.check_hash
    - path: {{ chromium.dir.tmp }}/chromium-{{ chromium.version }}
    - file_hash: {{ chromium.pkg.macapp.source_hash }}
    - require:
      - cmd: chromium-macos-app-install-curl
    - require_in:
      - macpackage: chromium-macos-app-install-macpackage
  file.absent:
    - name: {{ chromium.dir.tmp }}/chromium-{{ chromium.version }}
    - onfail:
      - module: chromium-macos-app-install-checksum

chromium-macos-app-install-macpackage:
  macpackage.installed:
    - name: {{ chromium.dir.tmp }}/chromium-{{ chromium.version }}
    - store: True
    - dmg: True
    - app: True
    - force: True
    - allow_untrusted: True
    - onchanges:
      - cmd: chromium-macos-app-install-curl
  file.append:
    - name: '/Users/{{ chromium.rootuser }}/.bash_profile'
    - text: 'export PATH=$PATH:/Applications/Chromium.app/Contents/MacOS/chromium'
    - require:
      - macpackage: chromium-macos-app-install-macpackage

    {%- else %}

chromium-macos-app-install-unavailable:
  test.show_notification:
    - text: |
        The Chromium macpackage is only available on MacOS

    {%- endif %}
