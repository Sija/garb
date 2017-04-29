module Garb
  module Management
    class Segment
      extend Attributes
      include PathAttribute

      attr_reader :session
      ga_attribute :name, :definition, id: 'segmentId'

      def self.all(session = Session)
        feed = Feed.new(session, '/segments')
        feed.entries.map { |entry| new(entry, session) }
      end

      def initialize(entry, session)
        @entry = entry
        @session = session
      end
    end
  end
end
