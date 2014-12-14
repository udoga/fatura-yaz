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
    skip 'generates pdf'
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

  def test_draws_table
    skip 'generates pdf'
    table_data = [["Cell 11\nLine 2", 'Cell 12'], ['Cell 21', 'Cell 22']]
    first_row_options = [{:left => [100, 200]}, {:center => [180, 200], :width => 10}]
    table_options = {:row_space => 10}
    @writer.write_table_data table_data, first_row_options, table_options
    @writer.render_file '../output.pdf'
  end

  private
  def set_text(text)
    @text = text
    @text_width = @writer.width_of(text)
  end
end