Version 0.9.8

  * Switched to `Net::HTTP.new` as `Net::HTTP.start` doesn't honor timeout values (http://www.ruby-forum.com/topic/148968)
  * Use @session.api_key for every data request, fixes #19
  * Hack to add support for dynamic segments (props to @stevenwilkin)
  * Tests are running green again

Version 0.9.7

  * Fixed bug causing Garb::Model#all_results to return nil if no limit provided
  * Don't error out if goal Destination is missing steps
  * Fixed "undefined method `map' for nil:NilClass" [#7]
  * Single user requests supports fibers with `Garb.use_fibers = true` [#6]
  * Made Garb::ResultSet comparable

Version 0.9.6

  * Swapped Yajl/JSON for MultiJson
  * Fixed "NameError: uninitialized constant Forwardable"
  * Updated README

Version 0.9.5

  * Moved all Garb::*Error classes to separate file
  * Made all Garb::*Error classes inherit from Garb::Error
  * Fixed couple of outstanding failing tests
  * CA_CERT_FILE -> Garb.ca_cert_file
  * API key as an element of the session
  * Added `Garb.logger` module attribute
  * Logs responses coming from GAPI (if logger set)
  * Adds open_timeout support for Net::HTTP requests
  * Added Travis CI configuration file

Version 0.9.4

  * Fixed fetching all records
  * Adds custom error classes inheriting from ClientError
  * Made error messages a bit more descriptive
  * Adds WebsiteProperty#name and #website_url properties
  * Made Garb report its version with each request
  * Made FilterParameter#hash_to_params do not escape backslash. Fixes #74
  * Code cleanup

Version 0.9.3

  * Adds support for fetching all results to Garb::Model
  * ClientError handles properly error code and message from returned JSON
  * Switches to GAPI v3

Version 0.9.2

  * Removed all deprecated features: Garb::Report, Garb::Resource, Garb::Profile, and Garb::Account
  * Moved the differing types of requests into a module, will refactor to share more code
  * Fixed OR'ing in :filters option for results

Version 0.9.0

  * New Garb::Model is solid. Garb::Resource and Garb::Report are deprecated.
  * New GA Management API is functional and should be used in place of Garb::Profile and Garb::Account

Version 0.7.4

  * Removes HappyMapper dependency in favor of Crack so we can drop libxml dependency

Version 0.7.0

  * Adds multi-session support

Version 0.6.0

  * Adds OAuth access token support
  * Simplifies Garb report access through a profile
  * Includes the start of a basic library of pre-built reports (require 'garb/reports')

Version 0.5.1

  * Brings back hash filters and symbol operators after agreed upon SymbolOperator

Version 0.5.0

  * Filters now have a new DSL so that I could toss Symbol operators (which conflict with DataMapper and MongoMapper)
  * The method of passing a hash to filters no longer works, at all

Version 0.4.0

  * Changes the api for filters and sort making it consistent with metrics/dimensions
  * If you wish to clear the defaults defined on a class, you may use clear_(filters/sort/metrics/dimensions)
  * To make a custom class using Garb::Resource, you must now extend instead of include the module

Version 0.3.2

  * Adds Profile.first which can be used to get the first profile with a table id, or web property id (UA number)

Version 0.2.4

  * Requires happymapper from rubygems, version 0.2.5. Be sure to update

Version 0.2.0

  * Makes major changes (compared to 0.1.0) to the way garb is used to build reports
  * There is now both a module that gets included for generating defined classes
  * Slight changes to the way that the Report class can be used
