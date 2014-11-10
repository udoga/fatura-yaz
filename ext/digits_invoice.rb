require 'prawn'
require 'prawn/table'

class DigitsInvoice
  def initialize
    @pdf = Prawn::Document.new(margin: 0, page_size: 'A4')
    @pdf.font '../fonts/VeraMono.ttf'
    @pdf.font_size 10
    @pdf.default_leading = 2
  end

  def generate
    draw_text 'Internet      :  www.example.com', at: [336, 704], size: 9
    draw_text 'Tic. Sicil No :  750000',            at: [336, 689], size: 9
    draw_text 'ABCD Yazılım ve Dan. Tic. Ltd. Şti.', at: [80, 633]
    @pdf.text_box "\nİnkılap Mah. Küçüksu Cad. No:111/1" +
                      "\n34768         Ümraniye / İstanbul", at: [80, 626], width: 230, height: 42
    draw_text '25/08/2014', at: [429, 619]
    draw_text '17:00', at: [429, 590]
    draw_text 'ÜMRANİYE', at: [80, 548]
    draw_text '7360000000', at: [358, 548]

    @pdf.bounding_box [80, 502], width: 449, height: 300 do
      line_items = [["Teknik Hizmet Bedeli\n( 000 TL / Gün )", '20', 'Gün', '000.00', '00,000.00']]
      @pdf.table(line_items, column_widths: [219, 36, 22, 63, 108],
                 cell_style: {border_width: 0, padding: [0, 0, 16, 0]}) do
        column(1).style :align => :center
        column(2).style :align => :center
        column(3).style :align => :right
        column(4).style :align => :right
      end
    end

    draw_text 'SIFIR TL.', at: [80, 162]
    draw_text '00,000.00', at: [529, 162], align: :right
    draw_text '00', at: [421, 131], align: :right
    draw_text '0,000.00', at: [529, 131], align: :right
    draw_text '00,000.00', at: [529, 100], align: :right
    draw_text 'Hesap No    : Isbank TR000000000000000000000000', at: [44, 130]
    draw_text 'Teslim Alan : ', at: [44, 100]

    @pdf.render_file('output.pdf')
  end

  def draw_text(text, options)
    align = options.delete(:align)
    if align and options[:at]
      text_width = @pdf.width_of(text)
      shift_amount = {:left => 0, :right => text_width, :center => text_width/2}[align]
      raise ArgumentError, "invalid alignment value '#{align}'" unless shift_amount
      options[:at][0] -= shift_amount
    end
    @pdf.draw_text(text, options)
  end
end

d = DigitsInvoice.new
d.generate
