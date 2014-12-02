require 'minitest/autorun'
require_relative '../lib/config_validator'
require_relative '../lib/invoice_config'

class TestConfigValidator < MiniTest::Test
  def setup
    @validator = ConfigValidator.new
  end

  def test_validates_options
    assert_valid_options({:left => [0, 0]})
    assert_invalid_options({:left => [0, 0], :something => 'value'}, "Invalid attribute: 'something'")
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

  def test_shows_all_errors_in_options
    assert_invalid_options({:something => 'value', :left => 'wrong type'},
        "Invalid attribute: 'something'\n'left' value must be an integer array.")
    assert_invalid_options({:width => 'wrong type'},
        "'width' value must be an integer.\nThe position attribute is required.")
  end

  def test_validates_config
    assert_valid_config({})
    assert_valid_config({'something' => 'value'})
    assert_valid_config({'date' => {'left' => [0, 0]}})
    assert_invalid_config({'date' => {'left' => [0, 0], 'something' => 'value'}},
        "date\nInvalid attribute: 'something'")
    assert_invalid_config({'time' => {'center' => [0, 'a']}, 'buyer-address' => {'width' => 230}},
        "time\n'center' value must be an integer array.\n\nbuyer-address\nThe position attribute is required.")
    assert_invalid_config({'buyer-name' => {'right' => [0]}, 'buyer-address' => {'something' => 'value'}},
"buyer-name
'right' value array size must be 2.

buyer-address
Invalid attribute: 'something'
The position attribute is required.")
  end

  def test_validate_valid_yml
    config = InvoiceConfig.from_file('config/valid.yml')
    @validator.validate_config config
  end

  def test_validates_addenda
    assert_valid_config({'addenda' => {'content' => {'left' => [0, 0]}}})
    assert_invalid_config({'addenda' => {'content' => {'wrong_option' => 'value'}}},
        "addenda - 'content'\nInvalid attribute: 'wrong_option'\nThe position attribute is required.")
  end

  def test_invalid_config_if_missing_options
    assert_invalid_config({'date' => 1}, "date\nMissing options.")
    assert_invalid_config({'buyer-name' => 'value', 'addenda' => 1},
        "buyer-name\nMissing options.\n\naddenda\nMissing contents.")
    assert_invalid_config({'addenda' => {'content' => 'value'}},
        "addenda - 'content'\nMissing options.")
  end

  private
  def assert_valid_options(options)
    @validator.validate_options(options)
  end

  def assert_invalid_options(options, message=nil)
    exception = assert_raises(ConfigValidator::InvalidOptions) do
      @validator.validate_options(options)
    end
    assert_equal message, exception.message if message
  end

  def assert_valid_config(params)
    config = InvoiceConfig.new(params)
    @validator.validate_config(config)
  end

  def assert_invalid_config(params, message=nil)
    config = InvoiceConfig.new(params)
    exception = assert_raises(ConfigValidator::InvalidConfig) do
      @validator.validate_config config
    end
    assert_equal message, exception.message if message
  end
end