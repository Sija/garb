require 'test_helper'

module Garb
  class ResultSetTest < MiniTest::Unit::TestCase
    context 'Adding result sets' do
      setup do
        @first = ResultSet.new(%w[a b])
        @second = ResultSet.new(%w[c])
      end

      should 'concatenate the results' do
        assert_equal %w[a b c], (@first + @second).to_a
      end

      should 'be sampled if any of the result sets is sampled' do
        @second.sampled = true
        assert((@first + @second).sampled?)
      end

      should 'not be sampled if none of the result sets is sampled' do
        assert !(@first + @second).sampled?
      end

      should 'accept an array' do
        assert_equal %w[a b c], (@first + %w[c]).to_a
      end
    end
  end
end
