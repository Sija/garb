require 'forwardable'

module Garb
  class ResultSet
    include Enumerable
    include Comparable
    extend Forwardable

    attr_accessor :results, :total_results, :sampled
    alias sampled? sampled

    def_delegators :results, :each, :to_a, :count, :size, :empty?

    def initialize(results)
      @results = results
    end

    def <=>(other)
      return nil unless other.is_a?(Garb::ResultSet)
      results <=> other.results
    end

    def +(other)
      copy = dup
      copy.results = @results + other.to_a
      copy
    end

    def [](*args)
      return @results[*args] if args.size == 1 && args.first.is_a?(Integer)
      copy = dup
      copy.results = @results[*args]
      copy
    end
  end
end
