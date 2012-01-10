module Garb
  module Management
    class Feed
      #BASE_URL = "https://www.google.com/analytics/feeds/datasources/ga"
      BASE_URL = "https://www.googleapis.com/analytics/v3/management"

      attr_reader :request

      def initialize(session, path)
        @request = Request::Data.new(session, BASE_URL+path)
      end

      def parsed_response
        @parsed_response ||= JSON.parse(response.body)
      end

      def entries
        parsed_response ? parsed_response['items'] : []
      end

      def response
        @response ||= request.send_request
      end
    end
  end
end
