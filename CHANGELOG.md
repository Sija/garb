Version 0.9.9

  **Deprecation notice:** Google has shut down the Universal Analytics APIs (Core Reporting v3, Management v3) as well as ClientLogin, which `Garb` relies on, so it no longer works against live services. See the README for actively maintained GA4 replacement gems.

  Breaking changes

  * [#82](https://github.com/Sija/garb/pull/82): Require Ruby >= 3.2 (support for Ruby 1.9, Rubinius and JRuby was dropped along the way)
  * [#82](https://github.com/Sija/garb/pull/82): Replaced deprecated `MultiJson` with stdlib `JSON` and dropped the `multi_json` dependency
  * [#82](https://github.com/Sija/garb/pull/82): Added `ostruct` as a runtime dependency (no longer a default gem starting with Ruby 3.5)
  * [#78](https://github.com/Sija/garb/pull/78), [#75](https://github.com/Sija/garb/pull/75): `Garb::Model#all_results` coerces `:limit` and `:offset` with `Integer()` and raises `ArgumentError` for non-numeric values or values lower than 1

  Features

  * [#47](https://github.com/Sija/garb/pull/47): Added `:sampling_level` option to `Garb::Model#results` - [@ballcheck](https://github.com/ballcheck)
  * [#45](https://github.com/Sija/garb/pull/45): Defined equality (`==`, `eql?`, `hash`) of `SymbolOperator` instances, so they can be used as hash keys - [@cgunther](https://github.com/cgunther)

  Fixes

  * [#75](https://github.com/Sija/garb/pull/75): Fixed `Garb::Model#all_results` (`:all => true`) ignoring `:offset` after the first page - [@dblock](https://github.com/dblock)
  * [#75](https://github.com/Sija/garb/pull/75): `Garb::Model#all_results` returns an empty `ResultSet` instead of `nil` when `:offset` is past the end
  * [#77](https://github.com/Sija/garb/pull/77): `Garb::Model#results` no longer removes `:all` from the caller's options hash
  * [#79](https://github.com/Sija/garb/pull/79): `Garb::Model#all_results` requests only as many rows as needed for `:limit` (extracted `Garb::Model::MAX_RESULTS`)
  * [#80](https://github.com/Sija/garb/pull/80): Fixed `Garb::Model#all_results` raising `ArgumentError` when the response has no `totalResults`
  * [#81](https://github.com/Sija/garb/pull/81): Combined `ResultSet`s are marked as sampled if any of them was sampled
  * [#82](https://github.com/Sija/garb/pull/82): Fixed "method redefined" warning when the same report method is added more than once
  * [#37](https://github.com/Sija/garb/pull/37): Fixed "mismatched indentations" warning - [@amatsuda](https://github.com/amatsuda)

  Internal

  * [#76](https://github.com/Sija/garb/pull/76): Fixed specs failing to load on modern Ruby
  * Moved CI from Travis CI to GitHub Actions (Ruby 3.2, 3.3 and 3.4), added CodeQL analysis and Dependabot
  * Added `LICENSE` file (MIT)

Version 0.9.8

  * Switched to `Net::HTTP.new` as `Net::HTTP.start` doesn't honor timeout values (http://www.ruby-forum.com/topic/148968)
  * Use `Session#api_key` for every data request (#19)
  * Hack to add support for dynamic segments (props to @stevenwilkin)
  * Allow alphanumeric segment ids - [@bensaunders](https://github.com/bensaunders)
  * Tests are running green again

Version 0.9.7

  * Fixed bug causing `Garb::Model#all_results` to return `nil` if no limit provided
  * Don't error out if goal `Destination` is missing steps
  * Fixed "undefined method `map' for nil:NilClass" (#7)
  * Single user requests support fibers with `Garb.use_fibers = true` (#6)
  * Made `Garb::ResultSet` comparable

Version 0.9.6

  * Swapped Yajl/JSON for `MultiJson`
  * Fixed "NameError: uninitialized constant Forwardable"
  * Updated README

Version 0.9.5

  * Moved all `Garb::*Error` classes to a separate file
  * Made all `Garb::*Error` classes inherit from `Garb::Error`
  * Fixed a couple of outstanding failing tests
  * Replaced `CA_CERT_FILE` with `Garb.ca_cert_file`
  * Added API key as an attribute of the session
  * Added `Garb.logger` module attribute
  * Log responses coming from GAPI (if logger is set)
  * Added `open_timeout` support for `Net::HTTP` requests
  * Added Travis CI configuration file

Version 0.9.4

  * Fixed fetching all records
  * Added custom error classes inheriting from `ClientError`
  * Made error messages a bit more descriptive
  * Added `WebProperty#name` and `#website_url` properties
  * Made `Garb` report its version with each request
  * Made `FilterParameters#hash_to_params` not escape backslash (#74)
  * Code cleanup

Version 0.9.3

  * Added support for fetching all results to `Garb::Model`
  * `ClientError` properly handles error code and message from returned JSON
  * Switched to GAPI v3

Version 0.9.2

  * Removed all deprecated features: `Garb::Report`, `Garb::Resource`, `Garb::Profile`, and `Garb::Account`
  * Moved the differing types of requests into a module, will refactor to share more code
  * Fixed OR'ing in `:filters` option for results

Version 0.9.0

  * New `Garb::Model` is solid. `Garb::Resource` and `Garb::Report` are deprecated.
  * New GA Management API is functional and should be used in place of `Garb::Profile` and `Garb::Account`

Version 0.7.4

  * Removed HappyMapper dependency in favor of Crack so we can drop libxml dependency

Version 0.7.0

  * Added multi-session support

Version 0.6.0

  * Added OAuth access token support
  * Simplified `Garb` report access through a profile
  * Included the start of a basic library of pre-built reports (`require 'garb/reports'`)

Version 0.5.1

  * Brought back hash filters and symbol operators after agreed upon `SymbolOperator`

Version 0.5.0

  * Filters now have a new DSL so that I could toss Symbol operators (which conflict with DataMapper and MongoMapper)
  * The method of passing a hash to filters no longer works, at all

Version 0.4.0

  * Changed the API for filters and sort making it consistent with metrics/dimensions
  * If you wish to clear the defaults defined on a class, you may use `clear_(filters/sort/metrics/dimensions)`
  * To make a custom class using `Garb::Resource`, you must now extend instead of include the module

Version 0.3.2

  * Added `Profile.first` which can be used to get the first profile with a table id, or web property id (UA number)

Version 0.2.4

  * Requires happymapper from rubygems, version 0.2.5. Be sure to update

Version 0.2.0

  * Made major changes (compared to 0.1.0) to the way garb is used to build reports
  * There is now both a module that gets included for generating defined classes
  * Slight changes to the way that the Report class can be used
