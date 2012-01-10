require 'test_helper'

module Garb
  module Management
    class AccountTest < MiniTest::Unit::TestCase
      context "The Account class" do
        should "turn entries for path into array of accounts" do
          feed = stub(:entries => ["entry1"])
          Feed.stubs(:new).returns(feed)

          Account.stubs(:new_from_entry)
          Account.all

          assert_received(Feed, :new) {|e| e.with(Session, '/accounts')}
          assert_received(feed, :entries)
          assert_received(Account, :new_from_entry) {|e| e.with("entry1", Session)}
        end
      end

      context "an Account" do
        setup do
          entry = JSON.parse(read_fixture("account_management.json"))['items'].first
          @account = Account.new_from_entry(entry, Session)
        end

        should "extract id and title from GA entry" do
          assert_equal "www.google.com", @account.title
          assert_equal "1234", @account.id
        end

        should "extract a name from GA entry properties" do
          assert_equal "www.google.com", @account.name
        end

        should "combine the Account.path and the id into an new path" do
          assert_equal "/accounts/1234", @account.path
        end

        should "have a reference to the session it was created with" do
          assert_equal Session, @account.session
        end

        should "have web properties" do
          WebProperty.stubs(:for_account)
          @account.web_properties
          assert_received(WebProperty, :for_account) {|e| e.with(@account)}
        end

        should "have profiles" do
          Profile.stubs(:for_account)
          @account.profiles
          assert_received(Profile, :for_account) {|e| e.with(@account)}
        end

        should "have goals" do
          Goal.stubs(:for_account)
          @account.goals
          assert_received(Goal, :for_account) {|e| e.with(@account)}
        end
      end
    end
  end
end
