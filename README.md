Garb [![Gem Version](https://badge.fury.io/rb/garb.png)](http://badge.fury.io/rb/garb) [![Build Status](https://api.travis-ci.org/Sija/garb.svg?branch=master)](http://travis-ci.org/Sija/garb)
====

  http://github.com/Sija/garb

Google Shutting Down Deprecated Auth on April 20th, 2015
--------------------------------------------------------

On April 20th, Google will be shutting down ClientLogin, AuthSub, and OAuth 1.0. https://groups.google.com/forum/#!topic/google-analytics-api-notify/g8wbdUqEDd0

Legato
------

  There's rewritten and (moar) actively maintained version of the library in the form of [Legato](https://github.com/tpitale/legato).  
  You might want to check it out as it's mostly compatible with `Garb`.

Important Changes
-----------------

  This fork contains heavily modified version of vigetlab's `Garb` library.  
  It works only with version 3 of Google API.

  Please read CHANGELOG.

Description
-----------

  Provides a Ruby API to the Google Analytics API.

  https://developers.google.com/analytics/devguides/reporting/core/v3/coreDevguide

Basic Usage
===========

Single User Login
-----------------

```ruby
Garb::Session.api_key = api_key # required for 2-step authentication
Garb::Session.login(username, password)
```

OAuth Access Token
------------------

```ruby
Garb::Session.access_token = access_token # an instance of OAuth2::Client
```

Accounts, WebProperties, Profiles, and Goals
--------------------------------------------

```ruby
Garb::Management::Account.all
Garb::Management::WebProperty.all
Garb::Management::Profile.all
Garb::Management::Goal.all
```

Profiles for a UA- Number (a WebProperty)
-----------------------------------------

```ruby
profile = Garb::Management::Profile.all.detect { |p| p.web_property_id == 'UA-XXXXXXX-X' }
```

Define a Report Class
---------------------

```ruby
class Exits
  extend Garb::Model

  metrics :exits, :pageviews
  dimensions :page_path
end
```

Get the Results
---------------

```ruby
Exits.results(profile, filters: { :page_path.eql => '/' })
```

  OR shorthand

```ruby
profile.exits(filters: { :page_path.eql => '/' })
```

  Be forewarned, these numbers are for the last **30** days and may be slightly different from the numbers displayed in Google Analytics' dashboard for **1 month**.

Other Parameters
----------------

  * __start_date__: The date of the period you would like this report to start
  * __end_date__: The date to end, inclusive
  * __limit__: The maximum number of results to be returned
  * __offset__: The starting index
  * __all__: Return all results if true (which might result in several requests to GAPI)
  * __sampling_level__: Specify precision vs speed strategy (`default`, `faster`, `greater_precision`)

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

```ruby
:eql      => '==',
:not_eql  => '!=',
:gt       => '>',
:gte      => '>=',
:lt       => '<',
:lte      => '<='
```

  Operators on dimensions:

```ruby
:matches          => '==',
:does_not_match   => '!=',
:contains         => '=~',
:does_not_contain => '!~',
:substring        => '=@',
:not_substring    => '!@'
```

  Given the previous Exits example report in shorthand, we can add an option for filter:

```ruby
profile.exits(filters: { :page_path.eql => '/extend/effectively-using-git-with-subversion/' })
```

SSL
---

  Version 0.2.3 includes support for real ssl encryption for SINGLE USER authentication. First do:

```ruby
Garb::Session.login(username, password, secure: true)
```

  Next, be sure to download http://curl.haxx.se/ca/cacert.pem into your application somewhere.
  Then, point `Garb.ca_cert_file` property to that file.

  For whatever reason, simply creating a new certificate store and setting the defaults would
  not validate the google ssl certificate as authentic.

OPEN / READ TIMEOUT
-------------------

  The open and read timeout values used with the network client (Net::HTTP) are configurable.
  Both values default to 60 seconds.  

```ruby
Garb.open_timeout = 3
Garb.read_timeout = 3
```

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

Add this line to your application’s Gemfile:

```ruby
gem 'garb'
```

Then run:

```sh
bundle install
```

Contributors
------------

  Many Thanks, for all their help, goes to:

  * Patrick Reagan
  * Justin Marney
  * Nick Plante
  * James Cook
  * Chris Gunther
  * Sijawusz Pur Rahnama

License
-------

  (The MIT License)

  Copyright (c) 2011 Tony Pitale, Viget Labs

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
