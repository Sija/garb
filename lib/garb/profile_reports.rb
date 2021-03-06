module Garb
  module ProfileReports
    def self.add_report_method(klass)
      # demodulize leaves potential to redefine
      # these methods given different namespaces
      method_name = klass.name.to_s.demodulize.underscore
      return if method_name.empty?

      class_eval <<-CODE
        def #{method_name}(opts = {}, &block)
          #{klass}.results(self, opts, &block)
        end
      CODE
    end
  end
end
