module Garb
  module Management
    class Profile

      include ProfileReports
      include PathAttribute
      extend Attributes

      attr_reader :session
      ga_attribute :id, :name, { :account_id => 'accountId', :web_property_id => 'webPropertyId' }

      def self.all(session = Session, path = '/accounts/~all/webproperties/~all/profiles')
        feed = Feed.new(session, path)
        feed.entries.map { |entry| new(entry, session) }
      end

      def self.for_account(account)
        all(account.session, account.path + '/webproperties/~all/profiles')
      end

      def self.for_web_property(web_property)
        all(web_property.session, web_property.path + '/profiles')
      end

      def initialize(entry, session)
        @entry = entry
        @session = session
      end

      def goals
        Goal.for_profile(self)
      end
    end
  end
end
