require 'test_helper'

module Garb
  SpecialKlass = Class.new(OpenStruct)

  class ReportResponseTest < MiniTest::Unit::TestCase
    context "A ReportResponse" do
      context "with a report feed" do
        setup do
          @json = File.read(File.join(File.dirname(__FILE__), '..', '..', "/fixtures/report_feed.json"))
        end

        should "parse results from json" do
          response = ReportResponse.new(@json)
          assert_equal ['4', '4', '17', '1', '5'], response.results.map(&:pageviews)
        end

        should "default to returning an array of OpenStruct objects" do
          response = ReportResponse.new(@json)
          assert_equal [OpenStruct, OpenStruct, OpenStruct, OpenStruct, OpenStruct], response.results.map(&:class)
        end

        should "return an array of instances of a specified class" do
          response = ReportResponse.new(@json, SpecialKlass)
          assert_equal [SpecialKlass, SpecialKlass, SpecialKlass, SpecialKlass, SpecialKlass], response.results.map(&:class)
        end

        should "know the total number of results" do
          response = ReportResponse.new(@json)
          assert_equal 1261, response.results.total_results
        end

        should "know if the data has been sampled" do
          response = ReportResponse.new(@json)
          assert_equal true, response.results.sampled?
        end

        should "return results as ResultSet which acts as Array proxy" do
          response = ReportResponse.new(@json, SpecialKlass)
          results = response.results
          results_subset = results[0..1]
          
          assert_equal ResultSet, results.class
          assert_equal ResultSet, results_subset.class
          assert_equal results_subset.results, results.results[0..1]
        end
      end

      should "return an empty array if there are no results" do
        response = ReportResponse.new('result json')
        MultiJson.stubs(:load).with('result json').returns({'rows' => []})

        assert_equal [], response.results.to_a
      end
    end
  end
end
