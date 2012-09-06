$:.unshift File.dirname(__FILE__)

require 'net/http'
require 'net/https'

require 'cgi'
require 'ostruct'

begin
  require 'yajl/json_gem' # JSON.parse
rescue LoadError
  require 'json'
end

module Garb
  autoload :VERSION,          'garb/version'
  
  autoload :Attributes,       'garb/attributes'
  autoload :PathAttribute,    'garb/path_attribute'
  autoload :Destination,      'garb/destination'
  autoload :FilterParameters, 'garb/filter_parameters'
  autoload :Model,            'garb/model'
  autoload :ProfileReports,   'garb/profile_reports'
  autoload :ReportParameter,  'garb/report_parameter'
  autoload :ReportResponse,   'garb/report_response'
  autoload :ResultSet,        'garb/result_set'
  autoload :Session,          'garb/session'
  autoload :Step,             'garb/step'

  module Management
    autoload :Account,     'garb/management/account'
    autoload :Feed,        'garb/management/feed'
    autoload :Goal,        'garb/management/goal'
    autoload :Profile,     'garb/management/profile'
    autoload :Segment,     'garb/management/segment'
    autoload :WebProperty, 'garb/management/web_property'
  end

  module Request
    autoload :Authentication, 'garb/request/authentication'
    autoload :Data,           'garb/request/data'
  end
 end

module Garb
  extend self

  class << self
    attr_accessor :proxy_address, :proxy_port, :proxy_user, :proxy_password, :logger
    attr_writer   :read_timeout, :ca_cert_file
  end

  def read_timeout
    @read_timeout || 60
  end

  def ca_cert_file
    @ca_cert_file || raise(MissingCertFileError)
  end

  def log(str)
    logger.debug str unless logger.nil?
  end

  def to_google_analytics(thing)
    return thing.to_google_analytics if thing.respond_to?(:to_google_analytics)

    "#{$1}ga:#{$2}" if "#{thing.to_s.camelize(:lower)}" =~ /^(-)?(.*)$/
  end
  alias :to_ga :to_google_analytics

  def from_google_analytics(thing)
    thing.to_s.gsub(/^ga\:/, '').underscore
  end
  alias :from_ga :from_google_analytics

  def symbol_operator_slugs
    [:eql, :not_eql, :gt, :gte, :lt, :lte, :desc, :descending, :matches,
      :does_not_match, :contains, :does_not_contain, :substring, :not_substring]
  end

  # new(address, port = nil, p_addr = nil, p_port = nil, p_user = nil, p_pass = nil)

  # opts => open_timeout, read_timeout, ssl_timeout
  # probably just support open_timeout
end

require 'garb/support'
require 'garb/errors'
