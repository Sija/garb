module Garb
  module Request
    class Data
      def initialize(session, base_url, parameters = {})
        @session, @base_url, @parameters = session, base_url, parameters
      end

      def parameters
        @parameters ||= {}
      end

      def query_string
        params = parameters.dup
        params.merge!('key' => Garb::Session.api_key) unless Garb::Session.api_key.nil?
        params_list = params.map { |k, v| "#{k}=#{v}" }.join('&')
        params_list.empty? ? '' : "?#{params_list}"
      end

      def uri
        @uri ||= URI.parse(@base_url)
      end

      def send_request
        Garb.log "Garb::Request -> #{uri.path}#{query_string}"
        
        response = if @session.single_user?
          single_user_request
        elsif @session.oauth_user?
          oauth_user_request
        end
        
        Garb.log "Garb::Response -> #{response.inspect}"
        
        unless response.kind_of?(Net::HTTPSuccess) || (response.respond_to?(:status) && response.status == 200)
          body, parsed = response.body, JSON.parse(body) rescue nil
          if parsed and error = parsed['error']
            klass = case error['code']
              when 400 then BadRequestError
              when 401 then InvalidCredentialsError
              when 403 then InsufficientPermissionsError
              when 503 then BackendError
              else ClientError
            end
            raise klass.new(error['message'], error['code'], error['errors'], uri.to_s + query_string)
          else
            raise ClientError, body
          end
        end
        response
      end

      def single_user_request
        http = Net::HTTP.new(uri.host, uri.port, Garb.proxy_address, Garb.proxy_port)
        http.open_timeout = Garb.open_timeout
        http.read_timeout = Garb.read_timeout
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        unless @session.access_token.nil?
          http.get("#{uri.path}#{query_string}", {'Authorization' => "Bearer #{@session.access_token.token}"})
        else
          http.get("#{uri.path}#{query_string}", {'Authorization' => "GoogleLogin auth=#{@session.auth_token}", 'GData-Version' => '3'})
        end
      end

      def oauth_user_request
        @session.access_token.get("#{uri}#{query_string}", {'GData-Version' => '3'})
      end
    end
  end
end
