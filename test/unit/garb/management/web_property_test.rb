require 'test_helper'

module Garb
  module Management
    class WebPropertyTest < MiniTest::Unit::TestCase
      context "the WebProperty class" do
        should "turn entries for path into array of web properties" do
          feed = stub(:entries => ["entry1"])
          Feed.stubs(:new).returns(feed)

          WebProperty.stubs(:new)
          WebProperty.all

          assert_received(Feed, :new) {|e| e.with(Session, '/accounts/~all/webproperties')}
          assert_received(feed, :entries)
          assert_received(WebProperty, :new) {|e| e.with("entry1", Session)}
        end

        should "find all web properties for a given account" do
          WebProperty.stubs(:all)
          WebProperty.for_account(stub(:session => Session, :path => '/accounts/123456'))

          assert_received(WebProperty, :all) do |e|
            e.with(Session, '/accounts/123456/webproperties')
          end
        end
      end

      context "a WebProperty" do
        setup do
          entry = JSON.parse(read_fixture("ga_webproperty_management.json"))["items"].first

          @web_property = WebProperty.new(entry, Session)
        end

        should "have an id" do
          assert_equal "UA-7777-1", @web_property.id
        end

        should "have an account_id" do
          assert_equal "1", @web_property.account_id
        end

        should "combine the WebProperty.path and the id into an new path" do
          assert_equal "/accounts/1/webproperties/UA-7777-1", @web_property.path
        end

        should "have profiles" do
          Profile.stubs(:for_web_property)
          @web_property.profiles
          assert_received(Profile, :for_web_property) {|e| e.with(@web_property)}
        end

        should "have goals" do
          Goal.stubs(:for_web_property)
          @web_property.goals
          assert_received(Goal, :for_web_property) {|e| e.with(@web_property)}
        end
      end
    end
  end
end
