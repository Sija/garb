module Garb
  class ReportResponse

    def initialize(response_body, instance_klass = OpenStruct)
      @response_body = response_body
      @instance_klass = instance_klass
    end

    def results
      if @results.nil?
        @results = ResultSet.new(parse)
        @results.total_results = total_results
        @results.sampled = sampled?
      end
      @results
    end

    def total_results
      data[:total_results]
    end

    def sampled?
      data[:contains_sampled_data]
    end

    private
    def keys
      @keys ||= column_headers.map { |header| Garb.from_ga header['name'] }
    end

    def parse
      rows.map do |row|
        @instance_klass.new(Hash[*keys.zip(row).flatten])
      end
    end

    def column_headers
      data[:column_headers] || []
    end

    def rows
      data[:rows] || []
    end

    def data
      unless @data
        @data = MultiJson.load @response_body
        @data = @data.inject({}) do |data, pair|
          key, value = pair
          data[key.underscore.to_sym] = value
          data
        end
      end
      @data
    end
  end
end
