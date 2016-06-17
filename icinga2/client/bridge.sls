include:
  - icinga2.pki.node
  - icinga2.features.api

extend:
  icinga2_api_enable:
    file:
      - require:
        - x509: icinga2_node_cert
