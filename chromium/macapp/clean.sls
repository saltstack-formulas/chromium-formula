# -*- coding: utf-8 -*-
# vim: ft=sls

    {%- if grains.os_family == 'MacOS' %}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import chromium with context %}

chromium-macos-app-clean-files:
  file.absent:
    - names:
      - {{ chromium.dir.tmp }}
      - /Applications/Chromium.app

    {%- else %}

chromium-macos-app-clean-unavailable:
  test.show_notification:
    - text: |
        The chromium macpackage is only available on MacOS

    {%- endif %}
