module Garb
  class ReportResponse

    def initialize(response_body, instance_klass = OpenStruct)
      @data = response_body
      @instance_klass = instance_klass
    end

    def results
      if @results.nil?
        @results = ResultSet.new(parse)
        @results.total_results = parse_total_results
        @results.sampled = parse_sampled_flag
      end
      @results
    end

    def sampled?
    end

    private
    def parse
      rows.map do |row|
        @instance_klass.new(Hash[*keys.zip(row).flatten])
      end
    end

    def column_headers
      parsed_data['columnHeaders']
    end

    def keys
      column_headers.map { |header| Garb.from_ga(header['name']) }
    end

    def rows
      parsed_data['rows'] || []
    end

    def parse_total_results
      parsed_data['totalResults'].to_i
    end

    def parse_sampled_flag
      parsed_data['containsSampledData']
    end

    def parsed_data
      @parsed_data ||= JSON.parse(@data)
    end
  end
end
