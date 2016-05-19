{% from 'icinga2/map.jinja' import icinga2 with context %}

include:
 - icinga2.pki

icinga2_ca_dir:
  file.directory:
    - name: {{icinga2.ca_dir}}
    - user: {{icinga2.user}}
    - group: {{icinga2.group}}

icinga2_ca_key:
  x509.private_key_managed:
    - name: {{icinga2.ca_dir}}/ca.key
    - bits: 4096
    - backup: True
    - require:
      - file: icinga2_ca_dir

icinga2_ca_key_perms:
  file.managed:
    - name: {{icinga2.ca_dir}}/ca.key
    - user: {{icinga2.user}}
    - group: {{icinga2.group}}
    - mode: 600
    - watch:
      - x509: icinga2_ca_key

icinga2_ca_cert:
  x509.certificate_managed:
    - name: {{icinga2.ca_dir}}/ca.crt
    - signing_private_key: {{icinga2.ca_dir}}/ca.key
    - CN: 'Icinga2 CA'
    - basicConstraints: "critical CA:true"
    - days_valid: 3650
    - backup: True
    - require:
      - x509: icinga2_ca_key

icinga2_ca_cert_perms:
  file.managed:
    - name: {{icinga2.ca_dir}}/ca.crt
    - user: {{icinga2.user}}
    - group: {{icinga2.group}}
    - watch:
      - x509: icinga2_ca_cert

/etc/salt/minion.d/signing_policies.conf:
  file.managed:
    - source: salt://icinga2/pki/signing_policies.conf
    - template: jinja
    - require:
      - x509: icinga2_ca_cert

# Restart the salt minion if the signing_policies changes
icinga2_restart_ca_minion:
  module.wait:
    - name: service.restart
    - m_name: salt-minion
    - watch:
      - file: /etc/salt/minion.d/signing_policies.conf

# Save the ca certificate in mine so the minions can collect it
icinga2_mine_ca_cert:
  module.run:
    - name: mine.update
    - onchanges:
      - x509: icinga2_ca_cert
