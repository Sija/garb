module Garb
  module Management
    class WebProperty
      extend Attributes
      include PathAttribute

      attr_reader :session, :entry
      ga_attribute :id, :name, :account_id, :website_url

      def self.all(session = Session, path = '/accounts/~all/webproperties')
        feed = Feed.new(session, path)
        feed.entries.map { |entry| new(entry, session) }
      end

      def self.for_account(account)
        all(account.session, account.path + '/webproperties')
      end

      def initialize(entry, session)
        @entry = entry
        @session = session
      end

      def profiles
        @profiles ||= Profile.for_web_property(self)
      end

      def goals
        @goals ||= Goal.for_web_property(self)
      end
    end
  end
end
