require 'prawn'

Prawn::Document.generate('output.pdf', page_size: 'A4', margin: 0) do
  text 'Hello World'
  text_box 'Sample text box.', at: [200, 500]
end