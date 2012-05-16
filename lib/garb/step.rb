module Garb
  class Step
    attr_reader :name, :number, :url

    def initialize(attributes)
      return unless attributes.is_a? Hash

      @name = attributes['name']
      @number = attributes['number']
      @url = attributes['url']
    end
  end
end
