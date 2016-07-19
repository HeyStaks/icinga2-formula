{% from 'icinga2/map.jinja' import icinga2 with context %}

include:
  - icinga2.pki

{% set fqdn = salt.grains.get('fqdn') %}

# Get ca certificate from mine
icinga2_node_ca_cert:
  x509.pem_managed:
    - name: {{icinga2.pki_dir}}/ca.crt
    - text: {{ salt['mine.get'](icinga2.master_minion_id, 'icinga2_ca_cert')[icinga2.master_minion_id]|replace('\n', '') }}
    - require:
      - file: icinga2_pki_dir

icinga2_node_ca_cert_perms:
  file.managed:
    - name: {{icinga2.pki_dir}}/ca.crt
    - user: {{icinga2.user}}
    - group: {{icinga2.group}}
    - watch:
      - x509: icinga2_node_ca_cert

# Create the key
icinga2_node_key:
  x509.private_key_managed:
    - name: {{icinga2.pki_dir}}/{{fqdn}}.key
    - bits: 4096
    - backup: True
    - require:
      - file: icinga2_pki_dir

icinga2_node_key_perms:
  file.managed:
    - name: {{icinga2.pki_dir}}/{{fqdn}}.key
    - user: {{icinga2.user}}
    - group: {{icinga2.group}}
    - mode: 600
    - watch:
      - x509: icinga2_node_key

# Create the certificate, send it to ca_server to be signed and store it as crt
icinga2_node_cert:
  x509.certificate_managed:
    - name: {{icinga2.pki_dir}}/{{fqdn}}.crt
    - ca_server: {{icinga2.master_minion_id}}
    - signing_policy: icinga2
    - public_key: {{icinga2.pki_dir}}/{{fqdn}}.key
    - CN: {{fqdn}}
    - backup: True
    - require:
      - x509: icinga2_node_key
    - onchanges:
      - x509: icinga2_node_ca_cert

icinga2_node_cert_perms:
  file.managed:
    - name: {{icinga2.pki_dir}}/{{fqdn}}.crt
    - user: {{icinga2.user}}
    - group: {{icinga2.group}}
    - watch:
      - x509: icinga2_node_cert
