=======
icinga2
=======

Icinga2 Formula

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Features
========

This formula can install, configure and run Icinga2. Can implement a single server or a cluster.

In cluster mode it is tested for `Local Configuration <http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/icinga2-client#icinga2-client-configuration-local>`_ scenario. So in this case Saltstack manage the changes of the configurations for each Icinga2 Client

Compatibility
=============

**Saltstack**: 2015.8.8

**Icinga2**: 2.4.8

Available states
================

.. contents::
    :local:

``icinga2``
-----------

* Configure icinga2 repo
* Install icinga2 package
* Run icinga service

``icinga2.conf``
----------------

Configure almost all the options for icinga2 reading information from default values and/or pillar. It uses a wrapper to generate each configuration file programmaticaly reading the data from yaml. The `defaults.yaml <https://github.com/HeyStaks/icinga2-formula/tree/master/icinga2/defaults.yaml>`_ file has all the values for the default configuration of the basic installation for icinga2

``icinga2.pki``
---------------

* Install python-m2crypto dependency
* Create base directory for pki

``icinga2.pki.ca``
******************

Setup an CA for icinga2 to use. It uses the features of saltstack and the `x509 <https://docs.saltstack.com/en/latest/ref/states/all/salt.states.x509.html#module-salt.states.x509>`_ state module. It exports the CA certificate to the saltstack mine for other nodes to use it

``icinga2.pki.master``
**********************

Create the master certificate, send it to the CA server to sign it and retrieve the signed certificate to store it. Then it exports the certificate to the mine for other nodes to use it

``icinga2.pki.node``
********************

Create the node certificate, send it to the CA server to sign it and retrieve the signed certificate to store it. It also retrieves the master certificate.

``icinga2.features``
--------------------

Configure and enable features. For now it only manage the *api* feature

``icinga2.node``
----------------

* Run pki node
* Run config
* Run features

``icinga2.master``
------------------

* Run pki master
* Run config
* Run features

Running
=======

Standalone
----------

If you want to only install and run icinga with default configs

.. code-block:: bash

    salt '*' state.sls icinga2

If you want to only install and run icinga with default configs

.. code-block:: bash

    salt '*' state.sls icinga2.config

Cluster
-------

You must first create an orchestration state to run the steps in the proper way. The formula provides an example on `test/salt/orch/icinga2.sls <https://github.com/HeyStaks/icinga2-formula/tree/master/test/salt/orch>`_ and then run

.. code-block:: bash

    salt-run state.orch orch.icinga2

The formula make use of saltstack mine functionality to store the certificates of the CA and master servers so you need to configure a couple of mine_functions to use this functionality.

Is also necessary to allow peer communication to allow communication between the minions that will become icinga2 nodes and the CA.

.. code-block:: yaml

    peer:
      .*:
        - x509.sign_remote_certificate

Example pillar files to have the settings necessary for a cluster deployment can be found on the `test/cluster <https://github.com/HeyStaks/icinga2-formula/tree/master/test/cluster>`_ folder

Ideas and future development
============================

* Implement a proper salt module to communicate with Icinga2. Via CLI and/or API
* Support other modes of Icinga2 clustering manager
* Add configuration for all the features

Template
========

This formula was created from a cookiecutter template.

See https://github.com/richerve/saltstack-formula-cookiecutter.
