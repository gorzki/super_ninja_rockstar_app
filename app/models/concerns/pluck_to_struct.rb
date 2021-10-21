module PluckToStruct
  extend ActiveSupport::Concern

  module ClassMethods
    def pluck_to_hash(*keys)
      block_given = block_given?
      hash_type = keys.extract_options!.fetch(:hash_type, HashWithIndifferentAccess)
      keys, formatted_keys = format_keys(keys)

      pluck(*keys).map do |row|
        value = hash_type[formatted_keys.zip(Array(row))]
        block_given ? yield(value) : value
      end
    end

    def pluck_to_struct(*keys)
      block_given = block_given?
      struct_type = keys.extract_options!.fetch(:struct_type, Struct)
      keys, formatted_keys = format_keys(keys)

      struct = respond_with_struct(struct_type, formatted_keys)
      pluck(*keys).map do |row|
        value = struct.new(*Array(row))
        block_given ? yield(value) : value
      end
    end

    private

    def respond_with_struct(struct_type, formatted_keys)
      return struct_type if struct_type.respond_to?(:members)
      struct_type.new(*formatted_keys)
    end

    def format_keys(keys)
      return [column_names, column_names] if keys.blank?
      [keys, regexp_keys(keys)]
    end

    def regexp_keys(keys)
      keys.map do |key|
        case key
        when String
          key.split(/\bas\b/i)[-1].strip.to_sym
        when Symbol
          key
        end
      end
    end

    alias_method :pluck_h, :pluck_to_hash
    alias_method :pluck_s, :pluck_to_struct
  end
end