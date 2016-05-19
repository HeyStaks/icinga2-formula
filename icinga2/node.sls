include:
  - icinga2.pki.node
  - icinga2.config
  - icinga2.features

extend:
  icinga2_api_enable:
    file:
      - require:
        - x509: icinga2_node_cert
