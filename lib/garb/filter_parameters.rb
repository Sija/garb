module Garb
  class FilterParameters
    attr_accessor :parameters

    def initialize(parameters)
      self.parameters = (Array.wrap(parameters) || []).compact
    end

    def to_params
      value = array_to_params(parameters)
      value.empty? ? {} : { 'filters' => value }
    end

    private

    def array_to_params(arr)
      arr.map do |param|
        case param
        when Hash  then hash_to_params(param)
        when Array then array_to_params(param)
        end
      end.join(',') # Array OR
    end

    def hash_to_params(hsh)
      hsh = hsh.map do |k, v|
        next unless k.is_a?(SymbolOperatorMethods)

        escaped_k = k.to_google_analytics.gsub(/([<>=])/) { |c| CGI.escape(c) }
        escaped_v = v.to_s.gsub(/([,;])/) { |c| '\\' + c }

        "#{escaped_k}#{CGI.escape(escaped_v)}"
      end
      # Hash AND (no duplicate keys), escape char for ';' fixes oauth
      hsh.join('%3B')
    end
  end
end
