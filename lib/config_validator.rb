class ConfigValidator
  def validate_options(options)
    validate_attributes_and_types(options)
    validate_position_key(options)
  end

  def validate_attributes_and_types(options)
    options.each do |attribute, value|
      if is_position_key(attribute)
        raise InvalidOptions.new, "'#{attribute}' value must be an integer array." unless (value.is_a? Array and
            value.all? {|i| i.is_a? Integer})
        raise InvalidOptions.new "'#{attribute}' value array size must be 2." unless value.size == 2
      elsif [:width, :height, :size].include? attribute
        raise InvalidOptions.new "'#{attribute}' value must be an integer." unless value.is_a? Integer
      elsif attribute == :single_line
        raise InvalidOptions.new "'#{attribute}' value must be boolean." unless !!value == value
      else
        raise InvalidOptions.new, "Invalid attribute: '#{attribute}'"
      end
    end
  end

  def validate_position_key(options)
    position_keys = get_position_keys(options)
    raise InvalidOptions.new, 'The position attribute is required.' if position_keys.empty?
    raise InvalidOptions.new, 'There can be only one position attribute.' if position_keys.size > 1
  end

  def get_position_keys(options)
    options.keys.select {|key| is_position_key(key)}
  end

  def is_position_key(attribute)
    [:left, :center, :right].include? attribute
  end

  class InvalidOptions < StandardError
  end
end