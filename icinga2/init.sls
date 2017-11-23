{% from "icinga2/map.jinja" import icinga2 with context %}

{% if grains['os_family'] == 'Debian' %}
icinga2_repo:
  pkgrepo.managed:
    - humanname: Icinga2 official repo
    - name: {{ icinga2.pkg_repo }}
    - file: /etc/apt/sources.list.d/icinga2.list
    - key_url: http://packages.icinga.org/icinga.key
{% elif grains['os_family'] == 'RedHat' %}
icinga2_repo:
  pkgrepo.managed:
    - humanname: ICINGA (stable release for epel)
    - name: icinga-stable-release
    - baseurl: http://packages.icinga.com/epel/$releasever/release/
    - gpgcheck: 1
    - gpgkey: http://packages.icinga.com/icinga.key
{% endif %}

icinga2_pkg:
  pkg.installed:
    - name: icinga2
    - require:
      - pkgrepo: icinga2_repo

icinga2_service:
  service.running:
    - name: icinga2
    - enable: True
    - reload: True

