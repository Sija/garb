module Garb
  module Model
    MONTH = 2592000
    URL = 'https://www.googleapis.com/analytics/v3/data/ga'

    def self.extended(base)
      ProfileReports.add_report_method(base)
      # base.set_instance_klass(base)
    end

    def metrics(*fields)
      @metrics ||= ReportParameter.new(:metrics)
      @metrics << fields
    end

    def dimensions(*fields)
      @dimensions ||= ReportParameter.new(:dimensions)
      @dimensions << fields
    end

    def set_instance_klass(klass)
      @instance_klass = klass
    end

    def instance_klass
      @instance_klass || OpenStruct
    end

    def results(profile, options = {})
      return all_results(profile, options) if options.delete(:all)

      start_date = options[:start_date] || Time.now - MONTH
      end_date = options[:end_date] || Time.now
      default_params = build_default_params(profile, start_date, end_date)

      param_set = [
        default_params,
        metrics.to_params,
        dimensions.to_params,
        parse_filters(options).to_params,
        parse_segment(options),
        parse_sort(options).to_params,
        build_page_params(options)
      ]
      data = send_request_for_data(profile, build_params(param_set))
      ReportResponse.new(data, instance_klass).results
    end

    def all_results(profile, options = {})
      options = options.dup
      limit = options.delete(:limit)
      options[:limit] = 10_000 # maximum allowed
      results = nil
      while ((rs = results(profile, options)) && !rs.empty?)
        results = results ? results + rs : rs
        options[:offset] = results.size + 1
        
        break if limit && results.size >= limit
        break if results.size >= results.total_results
      end
      limit && results ? results[0...limit] : results
    end
    
    private
    def send_request_for_data(profile, params)
      request = Request::Data.new(profile.session, URL, params)
      response = request.send_request
      response.body
    end

    def build_params(param_set)
      param_set.inject({}) { |p,i| p.merge i }.reject { |k,v| v.nil? }
    end

    def parse_filters(options)
      FilterParameters.new(options[:filters])
    end

    def parse_segment(options)
      # dirty hack to support dynamic segments
      if options.has_key?(:segment_id)
        segment = "gaid::#{options[:segment_id].to_i}"
      elsif options.has_key?(:dynamic_segment)
        filters = FilterParameters.new(options[:dynamic_segment])
        segment = "dynamic::#{filters.to_params['filters']}"
      end
      {'segment' => segment}
    end

    def parse_sort(options)
      sort = ReportParameter.new(:sort)
      sort << options[:sort] if options.has_key?(:sort)
      sort
    end

    def build_default_params(profile, start_date, end_date)
      {
        'ids' => Garb.to_ga(profile.id),
        'start-date' => format_time(start_date),
        'end-date' => format_time(end_date)
      }
    end

    def build_page_params(options)
      params = {}
      params['max-results'] = options[:limit] if options.has_key? :limit
      params['start-index'] = options[:offset] if options.has_key? :offset
      params
    end

    def format_time(t)
      t.strftime('%Y-%m-%d')
    end
  end
end
