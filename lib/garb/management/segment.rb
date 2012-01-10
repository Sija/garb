module Garb
  module Management
    class Segment
      attr_accessor :session, :path
      attr_accessor :id, :name, :definition

      def self.all(session = Session)
        feed = Feed.new(session, '/segments')
        feed.entries.map {|entry| new_from_entry(entry, session)}
      end

      def self.new_from_entry(entry, session)
        segment = new
        segment.session    = session
        segment.path       = entry["selfLink"].gsub(Feed::BASE_URL, '')
        segment.id = entry['segmentId']
        segment.name = entry['name']
        segment.definition = entry['definition']
        segment
      end
    end
  end
end
