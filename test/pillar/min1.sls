mine_functions:
  icinga2_ca_cert:
    - mine_function: x509.get_pem_entry
    - /var/lib/icinga2/ca/ca.crt
  icinga2_master_cert:
    - mine_function: x509.get_pem_entry
    - /etc/icinga2/pki/min1.crt
icinga2:
  master_host: min1
