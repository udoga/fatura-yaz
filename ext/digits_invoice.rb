require 'prawn'

class DigitsInvoice
  def initialize
    @pdf = Prawn::Document.new(margin: 0, page_size: 'A4')
    @pdf.font '../fonts/VeraMono.ttf'
    @pdf.font_size 10
    @pdf.default_leading = 2
  end

  def generate
    write 'Internet      :  www.example.com', left: [336, 711], size: 9
    write 'Tic. Sicil No :  750000', left: [336, 697], size: 9
    write 'ABCD Yazılım ve Dan. Tic. Ltd. Şti.', left: [80, 641]
    write "\nİnkılap Mah. Küçüksu Cad. No:111/1" +
          "\n34768         Ümraniye / İstanbul", left: [80, 627], width: 230, height: 42
    write '25/08/2014', left: [429, 627]
    write '17:00', left: [429, 598]
    write 'ÜMRANİYE', left: [80, 556]
    write '7360000000', left: [358, 556]
    write "Teknik Hizmet Bedeli\n  ( 000 TL / Gün )", left: [80, 499], width: 219
    write '20', center: [317, 499], width: 36
    write 'Gün', center: [346, 499], width: 22
    write '000.00', right: [421, 499], width: 63
    write '00,000.00', right: [529, 499], width: 108
    write 'SIFIR TL.', left: [80, 170]
    write '00,000.00', right: [529, 170]
    write '00', right: [421, 139]
    write '0,000.00', right: [529, 139]
    write '00,000.00', right: [529, 108]
    write 'Hesap No    : Isbank TR000000000000000000000000', left: [44, 139]
    write 'Teslim Alan : ', left: [44, 108]

    @pdf.render_file('digits_invoice.pdf')
  end

  def write(text, options)
    position_key = get_position_key(options.keys)
    width = get_item_width(text, options)
    shift_amount = {:left => 0, :center => width/2, :right => width}[position_key]
    position = options.delete(position_key)
    position[0] -= shift_amount
    options[:at] = position
    options[:align] = position_key if options[:width] or options[:height]
    @pdf.text_box(text, options)
  end

  # TODO: dogrulama. get_type. tyoe'a göre align konulacak.

  def get_position_key(option_keys)
    [:left, :center, :right].each do |position_key|
      return position_key if option_keys.include? position_key
    end
  end

  def get_item_width(text, options)
    return options[:width] if options[:width]
    # TODO: height varsa sayfa sonuna kadarki kismin iki kati donulecek.
    @pdf.width_of(text)
  end
end

d = DigitsInvoice.new
d.generate
