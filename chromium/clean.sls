# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import chromium with context %}
{%- set p = chromium.pkg %}

include:
             {%- if grains.os_family in ('MacOS',) %}
  -{{ ' .macapp.clean' if p.use_upstream_macapp else ' .package.clean' }}

             {%- else %}
  - .package.clean

             {%- endif %}
