def test_icinga2_pkg(Package):
    assert Package("icinga2").is_installed
