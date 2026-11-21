Garb [![Gem Version](https://badge.fury.io/rb/garb.svg)](https://badge.fury.io/rb/garb) [![CI](https://github.com/Sija/garb/actions/workflows/ci.yml/badge.svg)](https://github.com/Sija/garb/actions/workflows/ci.yml) [![License](https://img.shields.io/github/license/Sija/garb.svg)](https://github.com/Sija/garb/blob/master/LICENSE)
====

  https://github.com/Sija/garb

Deprecation Notice
------------------

**This gem is no longer functional against Google's live services and is kept for historical purposes only.**

  * `Garb` targets the Google Analytics **Core Reporting API v3** and **Management API v3** (Universal Analytics). Google stopped processing Universal Analytics data in July 2023 (July 2024 for Analytics 360) and has since shut both APIs down. See https://support.google.com/analytics/answer/11583528
  * Username/password authentication (`Garb::Session.login`) relies on **ClientLogin**, which Google shut down on April 20th, 2015. See https://developers.google.com/identity/protocols/AuthForInstalledApps
  * Google Analytics 4 (GA4) uses a different API with a different data model (e.g. `sessions`/`screenPageViews` instead of `ga:visits`/`ga:pageviews`, properties instead of profiles), so `Garb` cannot be pointed at it.

Replacements
------------

Use one of these actively maintained, Google-published gems instead:

  | Gem | Replaces | Notes |
  | --- | --- | --- |
  | [`google-analytics-data`](https://rubygems.org/gems/google-analytics-data) | Reporting (`Garb::Model`, `results`) | Official GA4 Data API client (gRPC-based, recommended) |
  | [`google-analytics-admin`](https://rubygems.org/gems/google-analytics-admin) | `Garb::Management::*` | Official GA4 Admin API client (accounts, properties, data streams, key events) |
  | [`google-apis-analyticsdata_v1beta`](https://rubygems.org/gems/google-apis-analyticsdata_v1beta) | Reporting | REST-based GA4 Data API client, lighter alternative to the gRPC one |
  | [`google-apis-analyticsadmin_v1beta`](https://rubygems.org/gems/google-apis-analyticsadmin_v1beta) | `Garb::Management::*` | REST-based GA4 Admin API client |

Authentication for all of the above is handled by [`googleauth`](https://rubygems.org/gems/googleauth) (service accounts, OAuth 2.0, Application Default Credentials).

[Legato](https://github.com/tpitale/legato), previously recommended here as a successor, also targets the retired Universal Analytics API and is no longer an option.

Migration guide: https://developers.google.com/analytics/devguides/migration/api/reporting-ua-to-ga4

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

  **Defunct:** ClientLogin was shut down by Google in April 2015; this method no longer works.

```ruby
Garb::Session.api_key = api_key # required for 2-step authentication
Garb::Session.login(username, password)
```

OAuth Access Token
------------------

  The only authentication method that was still supported until the Universal Analytics APIs were retired.

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

  **Defunct:** this only applies to single user (ClientLogin) authentication, see above.

  Version 0.2.3 includes support for real ssl encryption for SINGLE USER authentication. First do:

```ruby
Garb::Session.login(username, password, secure: true)
```

  Next, be sure to download https://curl.haxx.se/ca/cacert.pem into your application somewhere.
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

  * Ruby (tested on 3.2, 3.3 and 3.4)
  * activesupport >= 2.2
  * ostruct

Running Tests
-------------

  The test suite stubs all network calls, so no Google credentials or API keys are needed:

```sh
bundle install
bundle exec rake
```

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
