module Garb
  module Request
    class Data
      def initialize(session, base_url, parameters = {})
        @session, @base_url, @parameters = session, base_url, parameters
      end

      def parameters
        @parameters ||= {}
        @parameters['key'] ||= @session.api_key unless @session.api_key.nil?
        @parameters
      end

      def query_string
        params_list = parameters.map { |k, v| "#{k}=#{v}" }.join('&')
        params_list.empty? ? '' : "?#{params_list}"
      end

      def uri
        @uri ||= URI.parse(@base_url)
      end

      def absolute_uri
        uri.to_s + query_string
      end

      def relative_uri
        uri.path.to_s + query_string
      end

      def send_request
        Garb.log "Garb::Request -> #{relative_uri}"
        
        response = if @session.single_user?
          if Garb.use_fibers
            single_user_request_evented
          else
            single_user_request
          end
        elsif @session.oauth_user?
          oauth_user_request
        end
        
        Garb.log "Garb::Response -> #{response.inspect}"
        handle_response response
      end

      def handle_response(response)
        unless response.kind_of?(Net::HTTPSuccess) || (response.respond_to?(:status) && response.status == 200)
          body, parsed = response.body, MultiJson.load(response.body) rescue nil
          if parsed and error = parsed['error']
            klass = case error['code']
              when 400 then BadRequestError
              when 401 then InvalidCredentialsError
              when 403 then InsufficientPermissionsError
              when 503 then BackendError
              else ClientError
            end
            raise klass.new(absolute_uri, error['message'], error['code'], error['errors'])
          else
            raise ClientError.new(absolute_uri, body)
          end
        end
        response
      end

      def single_user_request_evented
        f = Fiber.current
        fiber = Fiber.new do
          f.resume single_user_request
        end
        fiber.resume
        Fiber.yield
      end

      def single_user_request
        http = Net::HTTP.new(uri.host, uri.port, Garb.proxy_address, Garb.proxy_port)
        http.open_timeout = Garb.open_timeout
        http.read_timeout = Garb.read_timeout
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        unless @session.access_token.nil?
          http.request_get(relative_uri, {'Authorization' => "Bearer #{@session.access_token.token}"})
        else
          http.request_get(relative_uri, {
            'Authorization' => "GoogleLogin auth=#{@session.auth_token}",
            'GData-Version' => '3'
          })
        end
      end

      def oauth_user_request
        @session.access_token.get(absolute_uri, {'GData-Version' => '3'})
      end
    end
  end
end
