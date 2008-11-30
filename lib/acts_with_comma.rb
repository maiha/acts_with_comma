module ActsWithComma
  ######################################################################
  ### Model
  module DecodeComma
    def acts_with_comma(*keys)
      keys.each do |key|
        acts_with_comma_columns << key.to_s.intern
        define_method("#{key}=") do |value|
          write_attribute(key, value.to_s.delete(',').to_i)
        end
      end
    end

    def acts_with_comma_columns
      @acts_with_comma_columns ||= Set.new
    end
  end

  ######################################################################
  ### Helper
  module EncodeComma
    def self.included(base)
      super
      base.class_eval do
        alias_method_chain :text_field, :encode_comma
      end
    end

    # wrapper to text_field with converting '1234567' to '1,234,567'
    def text_field_with_encode_comma(object_name, method, options = {})
      klass = object_name.to_s.classify.constantize rescue nil
      if klass and klass.respond_to?(:acts_with_comma_columns) and klass.acts_with_comma_columns.include?(method.to_s.intern)
        options[:value] ||= number_with_delimiter(instance_variable_get("@#{object_name}")[method])
      end
      text_field_without_encode_comma(object_name, method, options)
    end
  end
end
