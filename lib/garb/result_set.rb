require 'forwardable'

module Garb
  class ResultSet
    include Enumerable
    include Comparable
    extend Forwardable

    attr_accessor :results, :total_results, :sampled
    alias_method :sampled?, :sampled
    
    def_delegators :results, :each, :to_a, :count, :size, :empty?

    def initialize(results)
      @results = results
    end
    
    def <=>(other)
      results <=> other.results
    end
    
    def +(other)
      copy = self.dup
      copy.results = @results + other.to_a
      copy
    end
    
    def [](*args)
      return @results[*args] if args.size == 1 && args.first.is_a?(Integer)
      copy = self.dup
      copy.results = @results[*args]
      copy
    end
  end
end
