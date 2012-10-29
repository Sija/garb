module Garb
  module Management
    class Account
      extend Garb::Attributes
      include PathAttribute

      attr_reader :session
      ga_attribute :id, :name

      def initialize(entry, session)
        @entry = entry
        @session = session
      end

      def self.all(session = Session)
        feed = Feed.new(session, '/accounts')
        feed.entries.map { |entry| new(entry, session) }
      end

      def web_properties
        @web_properties ||= WebProperty.for_account(self)
      end

      def profiles
        @profiles ||= Profile.for_account(self)
      end

      def goals
        @goals ||= Goal.for_account(self)
      end
    end
  end
end
