# WPAPI

![GitHub](https://img.shields.io/github/license/bengarrett/wpapi?style=flat-square)
![Maintenance](https://img.shields.io/maintenance/no/2014?style=flat-square)

A simple application for CFML/Railo to interact with the [WordPress.com OAuth2](http://developer.wordpress.com/docs/oauth2/) authentication process and [call its API](http://developer.wordpress.com/docs/api/).

#### Introduction

This small collection of CFML pages allows you to interact with the WordPress.com API using the standard OAuth2 methods. The pages are kept simple to allow easy modification and customisation of the code.

#### Getting Started

The application requires no frameworks or 3rd party dependencies.

Simply copy the `wpapi` directory into the web root (`wwwroot`) of your CFML or Railo server. 

When done point your browser to the `index.cfm` within `wpapi`.

Often either `http://localhost:8080/wpapi/index.cfm` or `http://localhost:8888/wpapi/index.cfm`

The `index.cfm` contains all the instructions and optional configurations you may need.

#### Sample screenshots

A collection of preview screenshots can be found at https://github.com/bengarrett/wpapi/tree/master/screenshots

![Preview index.cfm](https://raw.githubusercontent.com/bengarrett/wpapi/master/screenshots/index.cfm.png)

#### Licence
[The MIT License (MIT)](http://opensource.org/licenses/MIT)
Copyright (c) 2014 Ben Garrett
