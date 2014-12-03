require 'yaml'

class InvoiceConfig
  attr_reader :page_size, :font_size, :font, :default_leading

  def initialize(params)
    @params = params.clone
    @page_size = params.delete('page_size') || 'A4'
    @font = params.delete('font') || 'Arial'
    @font_size = params.delete('font_size') || 10
    @default_leading = params.delete('default_leading') || 0
    @addenda = params.delete('addenda') || {}
    @page_items = params
  end

  def self.from_file(config_file)
    params = YAML.load_file(config_file)
    params = {} unless params.is_a? Hash
    return new(params)
  end

  def page_item(page_item_name)
    options = get_key_path_value(@page_items, page_item_name.split('.'))
    return {} unless options.is_a? Hash
    convert_keys_to_symbols(options.clone)
  end

  def addenda(content)
    options = @addenda[content]
    return {} unless options.is_a? Hash
    convert_keys_to_symbols(options.clone)
  end

  def get_addenda_contents
    return [] unless @addenda.is_a? Hash
    @addenda.keys
  end

  def get_parameter(path)
    get_key_path_value(@params, path.split('.'))
  end

  private
  def convert_keys_to_symbols(hash)
    hash.keys.each do |key|
      hash[key.to_sym] = hash.delete(key)
    end
    hash
  end

  def get_key_path_value(hash, key_path)
    result = hash
    key_path.each do |key|
      return nil unless result
      result = result[key]
    end
    result
  end
end