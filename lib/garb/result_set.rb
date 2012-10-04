require 'forwardable'

module Garb
  class ResultSet
    include Enumerable
    extend Forwardable

    attr_accessor :results, :total_results, :sampled
    alias_method :sampled?, :sampled
    
    def_delegators :results, :each, :concat, :to_a, :count, :size, :empty?

    def initialize(results)
      @results = results
    end
    
    def [](*args)
      copy = self.dup
      copy.results = @results[*args]
      copy
    end
  end
end
