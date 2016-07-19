{% from 'icinga2/map.jinja' import icinga2 with context %}

include:
  - icinga2.pki.cert

# Get master certificate from mine
icinga2_node_master_cert:
  x509.pem_managed:
    - name: {{icinga2.pki_dir}}/trusted-master.crt
    - text: {{ salt['mine.get'](icinga2.master_minion_id, 'icinga2_master_cert')[icinga2.master_minion_id]|replace('\n', '') }}
    - require:
      - file: icinga2_pki_dir

icinga2_node_master_cert_perms:
  file.managed:
    - name: {{icinga2.pki_dir}}/trusted-master.crt
    - user: {{icinga2.user}}
    - group: {{icinga2.group}}
    - watch:
      - x509: icinga2_node_master_cert
