module Garb
  module Attributes
    def self.extended(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def ga_attribute(*keys)
        hashes, symbols = keys.partition{|k| k.is_a?(Hash) }
        symbols.each do |key|
          define_a_method_for(key)
        end

        hashes.map{|hash| map_values_for(hash) }
      end

      private
      def define_a_method_for(key,custom_key=nil)
        define_method(key) do
          var = "@#{key}"
          hash_key = custom_key.nil? ? key.to_s : custom_key.to_s
          instance_variable_defined?(var) ? instance_variable_get(var) : instance_variable_set(var, @entry[hash_key])
        end unless method_defined?(key)
      end

      def map_values_for(hash)
        hash.each_pair do |key,value|
          define_a_method_for(key,value)
        end
      end
    end
  end
end
