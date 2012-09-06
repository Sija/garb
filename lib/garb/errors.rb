module Garb
  class Error < StandardError; end
  class MissingCertFileError < Error; end
  class AuthError < Error; end
  class ClientError < Error
    attr_reader :code, :message, :errors, :uri
    
    def initialize(message, code = nil, errors = [], uri = nil)
      @code, @message, @errors, @uri = code, message, errors, uri
    end
    
    def to_s
      "#{code ? "[#{code}] #{message}" : message} : #{uri}"
    end
  end
  class BadRequestError < ClientError; end
  class InvalidCredentialsError < ClientError; end
  class InsufficientPermissionsError < ClientError; end
  class BackendError < ClientError; end
end