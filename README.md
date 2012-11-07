Garb [![Build Status](https://secure.travis-ci.org/Sija/garb.png)](http://travis-ci.org/Sija/garb)
====

  http://github.com/codingluke/garb

Important Changes
=================

  This fork contains heavily modified version of vigetlab's `Garb` library.
  It works only with version 3 of Google API.

  Please read CHANGELOG

Description
-----------

  Provides a Ruby API to the Google Analytics API.

  https://developers.google.com/analytics/devguides/reporting/core/v3/coreDevguide

Basic Usage
===========

Single User Login
-----------------

    > Garb::Session.api_key = api_key # required for 2-step authentication
    > Garb::Session.login(username, password)

OAuth Access Token
------------------

    > Garb::Session.access_token = access_token # assign from oauth gem

Accounts, WebProperties, Profiles, and Goals
--------------------------------------------

    > Garb::Management::Account.all
    > Garb::Management::WebProperty.all
    > Garb::Management::Profile.all
    > Garb::Management::Goal.all

Profiles for a UA- Number (a WebProperty)
-----------------------------------------

    > profile = Garb::Management::Profile.all.detect {|p| p.web_property_id == 'UA-XXXXXXX-X'}

Define a Report Class
---------------------

    class Exits
      extend Garb::Model

      metrics :exits, :pageviews
      dimensions :page_path
    end

Get the Results
---------------

    > Exits.results(profile, :filters => {:page_path.eql => '/'})

  OR shorthand

    > profile.exits(:filters => {:page_path.eql => '/'})

  Be forewarned, these numbers are for the last **30** days and may be slightly different from the numbers displayed in Google Analytics' dashboard for **1 month**.

Get the Results (nonblocking)
_____________________________

    > Exits.results(profile, :nonblocking => true)

    Warning!! not working with OAuth Access Token!!!

Other Parameters
----------------

  * start_date: The date of the period you would like this report to start
  * end_date: The date to end, inclusive
  * limit: The maximum number of results to be returned
  * offset: The starting index
  * all: Return all results if true (which might result in several requests to GAPI)

Metrics & Dimensions
--------------------

  **Metrics and Dimensions are very complex because of the ways in which they can and cannot be combined.**

  I suggest reading the google documentation to familiarize yourself with this.

  https://developers.google.com/analytics/devguides/reporting/core/dimsmets#q=bouncerate

  When you've returned, you can pass the appropriate combinations to Garb, as symbols.

Filtering
---------

  Google Analytics supports a significant number of filtering options.

  https://developers.google.com/analytics/devguides/reporting/core/v3/reference#filters

  Here is what we can do currently:
  (the operator is a method on a symbol for the appropriate metric or dimension)

  Operators on metrics:

    eql => '==',
    not_eql => '!=',
    gt => '>',
    gte => '>=',
    lt => '<',
    lte => '<='

  Operators on dimensions:

    matches => '==',
    does_not_match => '!=',
    contains => '=~',
    does_not_contain => '!~',
    substring => '=@',
    not_substring => '!@'

  Given the previous Exits example report in shorthand, we can add an option for filter:

    profile.exits(:filters => {:page_path.eql => '/extend/effectively-using-git-with-subversion/')

SSL
---

  Version 0.2.3 includes support for real ssl encryption for SINGLE USER authentication. First do:

    Garb::Session.login(username, password, :secure => true)

  Next, be sure to download http://curl.haxx.se/ca/cacert.pem into your application somewhere.
  Then, point `Garb.ca_cert_file` property to that file.

  For whatever reason, simply creating a new certificate store and setting the defaults would
  not validate the google ssl certificate as authentic.

OPEN / READ TIMEOUT
-------------------

  The open and read timeout values used with the network client (Net::HTTP) are configurable.
  Both values default to 60 seconds.

    Garb.open_timeout = 3
    Garb.read_timeout = 3

TODOS
-----

  * rebuild AND/OR filtering in Garb::Model

Requirements
------------

  * active_support >= 2.2
  * multi_json >= 1.3

Requirements for Testing
------------------------

  * shoulda
  * mocha
  * bourne

Install
-------

    From git:

    `git clone git://github.com/Sija/garb.git`
    `cd garb && rake install`

    OR with bundler:

    gem 'garb', :git => 'git://github.com/Sija/garb.git'
    `bundle install`

Contributors
------------

  Many Thanks, for all their help, goes to:

  * Patrick Reagan
  * Justin Marney
  * Nick Plante
  * James Cook
  * Chris Gunther

License
-------

  (The MIT License)

  Copyright (c) 2011 Viget Labs

  Permission is hereby granted, free of charge, to any person obtaining
  a copy of this software and associated documentation files (the
  'Software'), to deal in the Software without restriction, including
  without limitation the rights to use, copy, modify, merge, publish,
  distribute, sublicense, and/or sell copies of the Software, and to
  permit persons to whom the Software is furnished to do so, subject to
  the following conditions:

  The above copyright notice and this permission notice shall be
  included in all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
