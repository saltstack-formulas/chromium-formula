# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import chromium with context %}
{%- set p = chromium.pkg %}

include:
  - .package.clean
