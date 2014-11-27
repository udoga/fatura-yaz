require 'minitest/autorun'
require_relative '../lib/page_writer'

class TestPageWriter < MiniTest::Test
  def setup
    @writer = PageWriter.new(margin: 0, page_size: 'A4')
    @writer.font '../fonts/Arial.ttf'
    @writer.font_size 10
    @writer.default_leading 2
    @page_width = @writer.page_dimensions[0]
  end

  def test_writes_pdf
    skip 'takes long time'
    @writer.write 'Sample text.', left: [100, 200]
    @writer.render_file '../output.pdf'
    assert File.exist?('../output.pdf')
  end

  def test_converts_position_keys
    set_text 'Sample text.'
    options = {:left => [300, 400]}
    result = {:at => [300, 400]}
    assert_equal result, @writer.convert_options(options, @text)
  end

  def test_shifts_position
    set_text 'Sample text.'
    options = {:right => [300, 400]}
    result = {:at => [300-@text_width, 400]}
    assert_equal result, @writer.convert_options(options, @text)

    options = {:center => [300, 400]}
    result = {:at => [300-@text_width/2, 400]}
    assert_equal result, @writer.convert_options(options, @text)
  end

  def test_adds_align_when_width_option
    set_text 'Sample text.'
    options = {:left => [300, 400], :width => 150}
    result = {:at => [300, 400], :width => 150, :align => :left}
    assert_equal result, @writer.convert_options(options, @text)

    options = {:right => [300, 400], :width => 150}
    result = {:at => [150, 400], :width => 150, :align => :right}
    assert_equal result, @writer.convert_options(options, @text)

    options = {:center => [300, 400], :width => 150}
    result = {:at => [225, 400], :width => 150, :align => :center}
    assert_equal result, @writer.convert_options(options, @text)
  end

  def test_calculates_wrapped_text_width
    set_text 'This is a long text. Passes next line when arrives the page end. The :width option not given.'
    options = {:left => [300, 400]}
    wrap_width = @page_width - 300
    result = {:at => [300, 400], :width => wrap_width, :align => :left}
    assert_equal result, @writer.convert_options(options, @text)

    options = {:right => [300, 400]}
    wrap_width = 300
    result = {:at => [0, 400], :width => wrap_width, :align => :right}
    assert_equal result, @writer.convert_options(options, @text)

    options = {:center => [300, 400]}
    wrap_width = @page_width - 300
    result = {:at => [300 - wrap_width, 400], :width => wrap_width*2, :align => :center}
    assert_equal result, @writer.convert_options(options, @text)
  end

  def test_not_wraps_when_single_line_option
    set_text 'This is a long text. Passes next line when arrives the page end. The :width option not given.'
    options = {:right => [300, 400], :single_line => true}
    result = {:at => [300 - @text_width, 400], :single_line => true}
    assert_equal result, @writer.convert_options(options, @text)
  end

  def test_validates_attributes_and_types
    assert_raises_invalid_options({:something => 'value'}, "Invalid attribute: 'something'")
    assert_raises_invalid_options({:left => 'wrong type'}, "'left' value must be an integer array.")
    assert_raises_invalid_options({:right => [2, 'wrong type']}, "'right' value must be an integer array.")
    assert_raises_invalid_options({:center => [1, 2, 3]}, "'center' value array size must be 2.")
    assert_raises_invalid_options({:left => [0, 0], :width => 'wrong type'}, "'width' value must be an integer.")
    assert_raises_invalid_options({:left => [0, 0], :single_line => 1}, "'single_line' value must be boolean.")
  end

  def test_validates_position_key
    assert_raises_invalid_options({}, 'The position attribute is required.')
    assert_raises_invalid_options({:width => 300}, 'The position attribute is required.')
    assert_raises_invalid_options({:left => [0, 0], :right => [0, 0]}, 'There can be only one position attribute.')
  end

  def set_text(text)
    @text = text
    @text_width = @writer.width_of(text)
  end

  def assert_raises_invalid_options(options, message=nil)
    set_text ''
    exception = assert_raises(PageWriter::InvalidOptions) do
      @writer.convert_options(options, @text)
    end
    assert_equal message, exception.message if message
  end
end