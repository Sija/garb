module Garb
  module Request
    class Authentication
      URL = 'https://www.google.com/accounts/ClientLogin'.freeze

      def initialize(email, password, opts = {})
        @email = email
        @password = password
        @account_type = opts[:account_type] || 'HOSTED_OR_GOOGLE'
      end

      def parameters
        {
          'Email'       => @email,
          'Passwd'      => @password,
          'accountType' => @account_type,
          'service'     => 'analytics',
          'source'      => "sija-garb-v#{Garb::VERSION}"
        }
      end

      def uri
        @uri ||= URI.parse(URL)
      end

      def send_request(ssl_mode)
        http = Net::HTTP.new(uri.host, uri.port, Garb.proxy_address, Garb.proxy_port)
        http.open_timeout = Garb.open_timeout
        http.read_timeout = Garb.read_timeout
        http.use_ssl = true
        http.verify_mode = ssl_mode

        if ssl_mode == OpenSSL::SSL::VERIFY_PEER
          http.ca_file = Garb.ca_cert_file
        end

        http.request(build_request) do |response|
          raise AuthError unless response.is_a?(Net::HTTPOK)
        end
      end

      def build_request
        post = Net::HTTP::Post.new(uri.path)
        post.set_form_data(parameters)
        post
      end

      def auth_token(opts = {})
        ssl_mode = opts[:secure] ? OpenSSL::SSL::VERIFY_PEER : OpenSSL::SSL::VERIFY_NONE
        send_request(ssl_mode).body.match(/^Auth=(.*)$/)[1]
      end
    end
  end
end
