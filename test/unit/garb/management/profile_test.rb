require 'test_helper'

module Garb
  module Management
    class ProfileTest < MiniTest::Unit::TestCase
      context "The Profile class" do
        should "turn entries for path into array of profiles" do
          feed = stub(:entries => ["entry1"])
          Feed.stubs(:new).returns(feed)

          Profile.stubs(:new)
          Profile.all

          assert_received(Feed, :new) {|e| e.with(Session, '/accounts/~all/webproperties/~all/profiles')}
          assert_received(feed, :entries)
          assert_received(Profile, :new) {|e| e.with("entry1", Session)}
        end

        should "find all profiles for a given account" do
          Profile.stubs(:all)
          Profile.for_account(stub(:session => 'session', :path => '/accounts/123'))
          assert_received(Profile, :all) {|e| e.with('session', '/accounts/123/webproperties/~all/profiles')}
        end

        should "find all profiles for a given web_property" do
          Profile.stubs(:all)
          Profile.for_web_property(stub(:session => 'session', :path => '/accounts/123/webproperties/456'))
          assert_received(Profile, :all) {|e| e.with('session', '/accounts/123/webproperties/456/profiles')}
        end
      end

      context "A Profile" do
        setup do
          entry = JSON.parse(read_fixture("ga_profile_management.json"))["items"].first
          @profile = Profile.new(entry, Session)
        end

        should "have a name" do
          assert_equal "the profile name", @profile.name
        end

        should "have an id" do
          assert_equal '2', @profile.id
        end

        should "have an account_id" do
          assert_equal '1234', @profile.account_id
        end

        should "have a web_property_id" do
          assert_equal 'UA-5555-1', @profile.web_property_id
        end

        should "have a path" do
          assert_equal "/accounts/1234/webproperties/UA-5555-1/profiles/2", @profile.path
        end

        should "have goals" do
          Goal.stubs(:for_profile)
          @profile.goals
          assert_received(Goal, :for_profile) {|e| e.with(@profile)}
        end
      end
    end
  end
end
