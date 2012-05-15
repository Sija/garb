module Garb
  class Destination
    attr_reader :match_type, :url, :steps, :case_sensitive

    alias :case_sensitive? :case_sensitive

    def initialize(attributes)
      return unless attributes.is_a?(Hash)

      @match_type = attributes['matchType']
      @url = attributes['url'] # TODO was @expression
      @case_sensitive = attributes['caseSensitive']

      @steps = attributes["steps"].map{|s| Step.new(s)}
    end
  end
end
