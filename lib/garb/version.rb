module Garb
  module VERSION

    MAJOR = 0
    MINOR = 9
    TINY  = 7

    def self.to_s # :nodoc:
      [MAJOR, MINOR, TINY].join '.'
    end

  end
end
