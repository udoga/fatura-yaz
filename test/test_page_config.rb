require 'minitest/autorun'
require_relative '../lib/page_config'

class TestPageConfig < MiniTest::Test
  def setup
    @config = PageConfig.from_file('config/valid.yml')
  end

  def test_gets_yaml_parameters
    assert_equal 'A4', @config.page_size
    assert_equal 12, @config.font_size
  end

  def test_has_default_values
    assert_equal 'Arial', @config.font
    assert_equal 0, @config.default_leading
  end

  def test_page_items
    assert_equal({:at => [429, 619]}, @config.page_items['date'])
    assert_equal(230, @config.page_items['buyer-address'][:width])
    assert_equal(:right, @config.page_items['general_total'][:align])
  end
end