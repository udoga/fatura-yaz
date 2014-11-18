require 'prawn'

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
    text_box "\nİnkılap Mah. Küçüksu Cad. No:111/1" +
             "\n34768         Ümraniye / İstanbul", at: [80, 626], width: 230, height: 42
    draw_text '25/08/2014', at: [429, 619]
    draw_text '17:00', at: [429, 590]
    draw_text 'ÜMRANİYE', at: [80, 548]
    draw_text '7360000000', at: [358, 548]

    text_box "Teknik Hizmet Bedeli\n  ( 000 TL / Gün )", at: [80, 499], width: 219
    text_box '20', at: [317, 499], width: 36, align: :center
    text_box 'Gün', at: [346, 499], width: 22, align: :center
    text_box '000.00', at: [421, 499], width: 63, align: :right
    text_box '00,000.00', at: [529, 499], width: 108, align: :right

    draw_text 'SIFIR TL.', at: [80, 162]
    draw_text '00,000.00', at: [529, 162], align: :right
    draw_text '00', at: [421, 131], align: :right
    draw_text '0,000.00', at: [529, 131], align: :right
    draw_text '00,000.00', at: [529, 100], align: :right
    draw_text 'Hesap No    : Isbank TR000000000000000000000000', at: [44, 130]
    draw_text 'Teslim Alan : ', at: [44, 100]

    @pdf.render_file('digits_invoice.pdf')
  end

  def text_box(text, options)
    align = options[:align]
    if align and options[:at]
      text_width = options[:width]
      shift_amount = {:left => 0, :right => text_width, :center => text_width/2}[align]
      raise ArgumentError, "invalid alignment value '#{align}'" unless shift_amount
      options[:at][0] -= shift_amount
    end
    @pdf.text_box(text, options)
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
