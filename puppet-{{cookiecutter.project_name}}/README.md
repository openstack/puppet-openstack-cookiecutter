Team and repository tags
========================

[![Team and repository tags](https://governance.openstack.org/tc/badges/{{cookiecutter.project_name}}.svg)](https://governance.openstack.org/tc/reference/tags/index.html)

<!-- Change things from this point on -->

#### Table of Contents

1. [Overview - What is the {{cookiecutter.project_name}} module?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with {{cookiecutter.project_name}}](#setup)
4. [Implementation - An under-the-hood peek at what the module is doing](#implementation)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
7. [Contributors - Those with commits](#contributors)

Overview
--------

The {{cookiecutter.project_name}} module is a part of [OpenStack](https://opendev.org/openstack), an effort by the OpenStack infrastructure team to provide continuous integration testing and code review for OpenStack and OpenStack community projects not part of the core software.  The module its self is used to flexibly configure and manage the FIXME service for OpenStack.

Module Description
------------------

The {{cookiecutter.project_name}} module is a thorough attempt to make Puppet capable of managing the entirety of {{cookiecutter.project_name}}.  This includes manifests to provision region specific endpoint and database connections.  Types are shipped as part of the {{cookiecutter.project_name}} module to assist in manipulation of configuration files.

Setup
-----

**What the {{cookiecutter.project_name}} module affects**

* [{{cookiecutter.project_name|capitalize}}](https://docs.openstack.org/{{cookiecutter.project_name|capitalize}}/latest), the FIXME service for OpenStack.

### Installing {{cookiecutter.project_name}}

    {{cookiecutter.project_name}} is not currently in Puppet Forge, but is anticipated to be added soon.  Once that happens, you'll be able to install {{cookiecutter.project_name}} with:
    puppet module install openstack/{{cookiecutter.project_name}}

### Beginning with {{cookiecutter.project_name}}

To utilize the {{cookiecutter.project_name}} module's functionality you will need to declare multiple resources.

Implementation
--------------

### {{cookiecutter.project_name}}

{{cookiecutter.project_name}} is a combination of Puppet manifest and ruby code to delivery configuration and extra functionality through types and providers.

Limitations
------------

* All the {{cookiecutter.project_name}} types use the CLI tools and so need to be ran on the {{cookiecutter.project_name}} node.

Development
-----------

Developer documentation for the entire puppet-openstack project.

* https://docs.openstack.org/puppet-openstack-guide/latest/

Contributors
------------

* https://github.com/openstack/puppet-{{cookiecutter.project_name}}/graphs/contributors
