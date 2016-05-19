{% from 'icinga2/map.jinja' import icinga2 with context %}

include:
  - icinga2

icinga2_api_conf:
  file.managed:
    - name: /etc/icinga2/features-available/api.conf
    - source: salt://icinga2/templates/api.conf.jinja
    - template: jinja
    - user: {{icinga2.user}}
    - group: {{icinga2.group}}
    - require:
      - pkg: icinga2_pkg

# Api enable
icinga2_api_enable:
  file.symlink:
    - name: /etc/icinga2/features-enabled/api.conf
    - target: /etc/icinga2/features-available/api.conf
    - require:
      - file: icinga2_api_conf
    - listen_in:
      - service: icinga2_service
