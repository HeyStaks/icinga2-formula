{% from 'icinga2/map.jinja' import icinga2 with context %}

include:
  - icinga2

# Install python-m2crypto dependency
{{icinga2.pki_pkg}}:
  pkg.installed:
    - require:
      - pkg: icinga2_pkg

icinga2_pki_dir:
  file.directory:
    - name: '/etc/icinga2/pki'
    - user: {{ icinga2.user }}
    - group: {{ icinga2.group }}
    - require:
      - pkg: {{icinga2.pki_pkg}}
