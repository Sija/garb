module Garb
  module ProfileReports
    def self.add_report_method(klass)
      # demodulize leaves potential to redefine
      # these methods given different namespaces
      method_name = klass.name.to_s.demodulize.underscore
      return if method_name.empty?

      # silence "method redefined" warnings without leaving a window where
      # the method is undefined: aliasing marks the current definition as
      # referenced, and removing the alias leaves the original in place
      if method_defined?(method_name, false)
        alias_method :__garb_redefine, method_name
        remove_method :__garb_redefine
      end

      class_eval <<-CODE
        def #{method_name}(opts = {}, &block)
          #{klass}.results(self, opts, &block)
        end
      CODE
    end
  end
end
