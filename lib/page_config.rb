require 'yaml'

class PageConfig
  private_class_method :new
  attr_reader :page_size, :font_size, :font, :default_leading, :page_items

  def initialize(params)
    @page_size = params.delete('page_size') || 'A4'
    @font = params.delete('font') || 'Arial'
    @font_size = params.delete('font_size') || '10'
    @default_leading = params.delete('default_leading') || 0

    @page_items = create_page_items(params)
  end

  def self.from_file(config_file)
    params = YAML.load_file(config_file)
    invoice_config = new(params)
    return invoice_config
  end

  def create_page_items(params)
    params.values.each do |attributes|
      attributes.keys.each do |attr_name|
        attributes[attr_name.to_sym] = attributes.delete(attr_name)
      end
    end
    params
  end
end