module Garb
  module Management
    class Goal
      extend Attributes
      include PathAttribute

      attr_reader :session
      ga_attribute :name, :number, :value, :active

      alias :active? :active

      def self.all(session = Session, path = '/accounts/~all/webproperties/~all/profiles/~all/goals')
        feed = Feed.new(session, path)
        feed.entries.map { |entry| new(entry, session) }
      end

      def self.for_account(account)
        all(account.session, account.path + '/webproperties/~all/profiles/~all/goals')
      end

      def self.for_web_property(web_property)
        all(web_property.session, web_property.path + '/profiles/~all/goals')
      end

      def self.for_profile(profile)
        all(profile.session, profile.path + '/goals')
      end

      def initialize(entry, session)
        @entry = entry
        @session = session
      end

      def destination
        @destination ||= Destination.new(@entry['urlDestinationDetails'])
      end
    end
  end
end
