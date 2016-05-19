{% from 'icinga2/map.jinja' import icinga2 with context %}

include:
  - icinga2.pki.cert

# Update the master certificate in mine so the minions can collect it
icinga2_mine_master_cert:
  module.run:
    - name: mine.update
    - onchanges:
      - x509: icinga2_node_cert
