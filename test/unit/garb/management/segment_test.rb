require 'test_helper'

module Garb
  module Management
    class SegmentTest < MiniTest::Unit::TestCase
      context "The Segment class" do
        should "turn entries for path into array of accounts" do
          feed = stub(:entries => ["entry1"])
          Feed.stubs(:new).returns(feed)

          Segment.stubs(:new)
          Segment.all

          assert_received(Feed, :new) {|e| e.with(Session, '/segments')}
          assert_received(feed, :entries)
          assert_received(Segment, :new) {|e| e.with("entry1", Session)}
        end
      end

      context "A Segment" do
        setup do
          entry = MultiJson.load(read_fixture("ga_segment_management.json"))["items"].first
          @segment = Segment.new(entry, Session)
        end

        should "have an id" do
          assert_equal "gaid::1", @segment.id
        end

        should "have a name" do
          assert_equal "derpy", @segment.name
        end

        should "have a definition" do
          assert_equal "ga:pagePath=@derpy", @segment.definition
        end
      end
    end
  end
end
