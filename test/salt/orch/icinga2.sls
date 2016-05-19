icinga2_configure_ca:
  salt.state:
    - tgt: 'min1'
    - sls:
      - icinga2.pki.ca

icinga2_configure_master:
  salt.state:
    - tgt: 'min1'
    - sls:
      - icinga2.master

icinga2_configure_nodes:
  salt.state:
    - tgt: 'min[2,3]'
    - sls:
      - icinga2.node
