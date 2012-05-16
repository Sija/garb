module Garb
  class ClientError < StandardError
    attr_reader :code, :message, :errors
    
    def initialize(code, message, errors = [])
      @code, @message, @errors = code, message, errors
    end
  end
  
  module Request
    class Data
      attr_writer :format

      def initialize(session, base_url, parameters = {})
        @session = session
        @base_url = base_url
        @parameters = parameters
      end

      def parameters
        @parameters ||= {}
      end

      def query_string
        parameters.merge!('key' => Garb.api_key) unless Garb.api_key.nil?
        parameters.merge!('alt' => format)
        parameter_list = parameters.map { |k,v| "#{k}=#{v}" }
        parameter_list.empty? ? '' : "?#{parameter_list.join('&')}"
      end

      def format
        @format ||= 'json' # TODO Support other formats?
      end

      def uri
        @uri ||= URI.parse(@base_url)
      end

      def send_request
        response = if @session.single_user?
          single_user_request
        elsif @session.oauth_user?
          oauth_user_request
        end

        unless response.kind_of?(Net::HTTPSuccess) || (response.respond_to?(:status) && response.status == 200)
          body = JSON.parse(response.body) rescue nil
          if body
            raise ClientError.new(body['error']['code'], body['error']['code'], body['error']['errors'])
          else
            raise ClientError, response.body.inspect
          end
        end
        response
      end

      def single_user_request
        http = Net::HTTP.new(uri.host, uri.port, Garb.proxy_address, Garb.proxy_port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http.get("#{uri.path}#{query_string}", {'Authorization' => "Bearer #{@session.access_token.token}"})
      end

      def oauth_user_request
        @session.access_token.get("#{uri}#{query_string}")
      end
    end
  end
end
