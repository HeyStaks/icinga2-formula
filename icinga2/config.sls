{% from "icinga2/map.jinja" import icinga2 with context %}
{% from "icinga2/macros.jinja" import printconfig with context %}
{% set confd_dir = icinga2.config_dir + '/' + icinga2.config_subdir %}

include:
  - icinga2

{{confd_dir}}:
  file.directory:
    - require:
      - pkg: icinga2

{% set conf_files = {"hosts": "object",
                    "groups": "object",
                    "templates": "template",
                    "downtimes": "apply",
                    "services": "apply",
                    "downtimes": "apply"}
%}

{% for object, type in conf_files.items() %}
  {% if icinga2.config[object] is defined %}
{{confd_dir}}/{{object}}.conf:
  file.managed:
    - listen_in:
      - service: icinga2_service
    - require:
      - file: {{confd_dir}}
    - contents: |
    {%- for obj, objopts in icinga2.config[object].items() %}
      {%- if objopts["for"] is defined %}
  {{ printconfig("apply", objopts["type"], obj, objopts["conf"], objopts["for"], "for") }}
      {%- elif objopts["to"] is defined %}
  {{ printconfig("apply", objopts["type"], obj, objopts["conf"], objopts["to"], "to") }}
      {%- else %}
  {{ printconfig(type, objopts["type"], obj, objopts["conf"]) }}
      {%- endif %}
    {%- endfor %}
  {%- endif %}
{%- endfor %}

icinga2_zones_conf:
  file.managed:
    - name: {{icinga2.config_dir}}/zones.conf
    - source: salt://icinga2/templates/zones.conf.jinja
    - template: jinja
    - require:
      - pkg: icinga2
    - listen_in:
      - service: icinga2_service
