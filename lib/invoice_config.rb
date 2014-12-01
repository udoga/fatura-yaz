require 'yaml'

class InvoiceConfig
  attr_reader :page_size, :font_size, :font, :default_leading

  def initialize(params)
    @page_size = params.delete('page_size') || 'A4'
    @font = '../fonts/' + (params.delete('font') || 'Arial') + '.ttf'
    @font_size = params.delete('font_size') || '10'
    @default_leading = params.delete('default_leading') || 0
    @addenda = params.delete('addenda') || {}
    @page_items = params
  end

  def self.from_file(config_file)
    params = YAML.load_file(config_file)
    invoice_config = new(params)
    return invoice_config
  end

  def page_item(page_item_name)
    attributes = get_key_path_value(@page_items, page_item_name.split('.'))
    return nil unless attributes
    convert_keys_to_symbols(attributes)
  end

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

  def addenda(content)
    attributes = @addenda[content]
    return nil unless attributes
    convert_keys_to_symbols(attributes)
  end

  def get_addenda_contents
    @addenda.keys
  end
end