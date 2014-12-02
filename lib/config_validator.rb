class ConfigValidator
  def validate_config(config)
    @config_error_message = nil
    validate_page_items_options(config)
    validate_addenda_options(config)
    raise InvalidConfig.new @config_error_message if @config_error_message
  end

  def validate_options(options)
    @options_error_message = nil
    validate_attributes_and_types(options)
    validate_position_key(options)
    raise InvalidOptions.new @options_error_message if @options_error_message
  end

  private
  def validate_page_items_options(config)
    page_item_names = %w(date time buyer-name buyer-address buyer-tax_office buyer-tax_office_no
line_items.description line_items.quantity line_items.unit line_items.unit_price line_items.line_total
total tax_rate tax_amount general_total general_total_reading)
    page_item_names.each do |page_item_name|
      options = config.page_item(page_item_name)
      validate_config_group(options, page_item_name)
    end
  end

  def validate_addenda_options(config)
    addenda_contents = config.get_addenda_contents
    if addenda_contents.is_a? Array
      addenda_contents.each do |addenda_content|
        options = config.addenda(addenda_content)
        validate_config_group(options, "addenda - '#{addenda_content}'")
      end
    else
      add_config_error_message "addenda\nMissing contents."
    end
  end

  def validate_config_group(options, title)
    if options
      if options.is_a? Hash
        begin
          validate_options(options)
        rescue InvalidOptions => e
          add_config_error_message "#{title}\n#{e.message}"
        end
      else
        add_config_error_message "#{title}\nMissing options."
      end
    end
  end

  def add_config_error_message(message)
    if @config_error_message
      @config_error_message += "\n\n#{message}"
    else
      @config_error_message = message
    end
  end

  def validate_attributes_and_types(options)
    options.each do |attribute, value|
      if is_position_key(attribute)
        if value.is_a? Array and value.all? { |i| i.is_a? Integer }
          add_options_error_message "'#{attribute}' value array size must be 2." unless value.size == 2
        else
          add_options_error_message "'#{attribute}' value must be an integer array."
        end
      elsif [:width, :height, :size].include? attribute
        add_options_error_message "'#{attribute}' value must be an integer." unless value.is_a? Integer
      elsif attribute == :single_line
        add_options_error_message "'#{attribute}' value must be boolean." unless !!value == value
      else
        add_options_error_message "Invalid attribute: '#{attribute}'"
      end
    end
  end

  def validate_position_key(options)
    position_keys = get_position_keys(options)
    add_options_error_message 'The position attribute is required.' if position_keys.empty?
    add_options_error_message 'There can be only one position attribute.' if position_keys.size > 1
  end

  def add_options_error_message(message)
    if @options_error_message
      @options_error_message += "\n#{message}"
    else
      @options_error_message = message
    end
  end

  def get_position_keys(options)
    options.keys.select {|key| is_position_key(key)}
  end

  def is_position_key(attribute)
    [:left, :center, :right].include? attribute
  end

  class InvalidConfig < StandardError
  end

  class InvalidOptions < StandardError
  end
end