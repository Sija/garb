require 'test_helper'

class SymbolOperatorTest < MiniTest::Unit::TestCase
  context "An instance of a SymbolOperator" do
    should "lower camelize the target" do
      assert_equal "ga:uniqueVisits==", SymbolOperator.new(:unique_visits, :eql).to_google_analytics
    end

    should "return target and operator together" do
      assert_equal "ga:metric==", SymbolOperator.new(:metric, :eql).to_google_analytics
    end

    should "prefix the operator to the target" do
      assert_equal "-ga:metric", SymbolOperator.new(:metric, :desc).to_google_analytics
    end

    should 'know if it is equal to another instance' do
      op1 = SymbolOperator.new(:hello, '==')
      op2 = SymbolOperator.new(:hello, '==')
      assert_equal op1, op2
      assert op1.eql?(op2)
      assert_equal op1.hash, op2.hash
    end

    should 'not be equal to another instance if different target or operator' do
      op1 = SymbolOperator.new(:hello1, '==')
      op2 = SymbolOperator.new(:hello2, '==')
      refute_equal op1, op2
      refute op1.eql?(op2)
      refute_equal op1.hash, op2.hash

      op1 = SymbolOperator.new(:hello, '!=')
      op2 = SymbolOperator.new(:hello, '==')
      refute_equal op1, op2
      refute op1.eql?(op2)
      refute_equal op1.hash, op2.hash
    end
  end
end
