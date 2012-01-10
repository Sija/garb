module Garb
  module Management
    class Profile

      include ProfileReports

      attr_accessor :session, :path
      attr_accessor :id, :name, :account_id, :web_property_id

      def self.all(session = Session, path = '/accounts/~all/webproperties/~all/profiles')
        feed = Feed.new(session, path)
        feed.entries.map {|entry| new_from_entry(entry, session)}
      end

      def self.for_account(account)
        all(account.session, account.path+'/webproperties/~all/profiles')
      end

      def self.for_web_property(web_property)
        all(web_property.session, web_property.path+'/profiles')
      end

      def self.new_from_entry(entry, session)
        profile = new
        profile.session = session
        profile.path = entry["selfLink"].gsub(Feed::BASE_URL, '')
        profile.id = entry['id']
        profile.name = entry['name']
        profile.account_id = entry['accountId']
        profile.web_property_id = entry['webPropertyId']
        profile
      end

      def goals
        Goal.for_profile(self)
      end
    end
  end
end
