module Garb
  module PathAttribute
    def path
      @path ||= @entry['selfLink'].gsub(Management::Feed::BASE_URL, '')
    end
  end
end
