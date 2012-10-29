module Garb
  module Attributes
    def self.extended(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def ga_attribute(*keys)
        hashes, symbols = keys.partition { |k| k.is_a? Hash }
        symbols.each { |key| define_a_method_for key }
        hashes.each { |hash| map_values_for hash }
      end

      private
      def define_a_method_for(key, custom_key = nil)
        custom_key ||= key.to_s.camelize(:lower)
        define_method(key) do
          var = "@#{key}"
          if instance_variable_defined? var
            instance_variable_get var
          else
            hash_key = (custom_key || key).to_s
            instance_variable_set var, @entry[hash_key]
          end
        end #unless method_defined?(key)
      end

      def map_values_for(hash)
        hash.each_pair do |key, value|
          define_a_method_for key, value
        end
      end
    end
  end
end
