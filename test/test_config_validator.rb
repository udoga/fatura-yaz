require 'minitest/autorun'
require_relative '../lib/config_validator'
require_relative '../lib/invoice_config'

class TestConfigValidator < MiniTest::Test
  def setup
    @validator = ConfigValidator.new
  end

  def test_validates_options
    assert_valid_options({:left => [0, 0]})
  end

  def test_validates_attributes_and_types
    assert_invalid_options({:something => 'value'}, "Invalid attribute: 'something'")
    assert_invalid_options({:left => 'wrong type'}, "'left' value must be an integer array.")
    assert_invalid_options({:right => [2, 'wrong type']}, "'right' value must be an integer array.")
    assert_invalid_options({:center => [1, 2, 3]}, "'center' value array size must be 2.")
    assert_invalid_options({:left => [0, 0], :width => 'wrong type'}, "'width' value must be an integer.")
    assert_invalid_options({:left => [0, 0], :single_line => 1}, "'single_line' value must be boolean.")
  end

  def test_validates_position_key
    assert_invalid_options({}, 'The position attribute is required.')
    assert_invalid_options({:width => 300}, 'The position attribute is required.')
    assert_invalid_options({:left => [0, 0], :right => [0, 0]}, 'There can be only one position attribute.')
  end

  def assert_valid_options(options)
    @validator.validate_options(options)
  end

  def assert_invalid_options(options, message=nil)
    exception = assert_raises(ConfigValidator::InvalidOptions) do
      @validator.validate_options(options)
    end
    assert_equal message, exception.message if message
  end
end