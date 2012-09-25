require 'test_helper'

module Garb
  module Management
    class FeedTest < MiniTest::Unit::TestCase
      context "a Feed" do
        setup do
          @request = stub
          Request::Data.stubs(:new).returns(@request)
          @feed = Feed.new(Garb::Session.new, '/accounts')
        end

        should "have a parsed response" do
          MultiJson.stubs(:load)
          @feed.stubs(:response).returns(stub(:body => 'response body'))
          @feed.parsed_response

          assert_received(MultiJson, :load) {|e| e.with('response body')}
        end

        should "have entries from the parsed response" do
          @feed.stubs(:parsed_response).returns({'items' => ['entry1', 'entry2']})
          assert_equal ['entry1', 'entry2'], @feed.entries
        end

        should "have an empty array for entries without a response" do
          @feed.stubs(:parsed_response).returns(nil)
          assert_equal [], @feed.entries
        end

        should "have a response from the request" do
          @request.stubs(:send_request)
          @feed.response
          assert_received(@request, :send_request)
        end
      end
    end
  end
end
