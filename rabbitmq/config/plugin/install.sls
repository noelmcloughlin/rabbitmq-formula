# -*- coding: utf-8 -*-
# vim: ft=sls
---
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as rabbitmq with context %}
{%- set sls_service_running = tplroot ~ '.service.running' %}

include:
  - {{ sls_service_running }}

    {%- if 'plugin' in rabbitmq and rabbitmq.plugin is mapping %}
        {%- for name in rabbitmq.plugin %}

rabbitmq-config-plugin-enabled-{{ name }}:
  rabbitmq_plugin.enabled:
    - name: {{ name }}
    - runas: {{ rabbitmq.plugin[name]['runas'] }}
    - watch_in:
      - sls: {{ sls_service_running }}
  cmd.run:
    - name: locale
    - onfail:
      - rabbitmq_plugin: rabbitmq-config-plugin-enabled-{{ name }}

        {%- endfor %}
    {%- endif %}
