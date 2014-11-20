require 'prawn'

Prawn::Document.generate('output.pdf', page_size: 'A4', margin: 0) do
  text 'Hello World'
  text_box 'Merhaba. Simdi buraya birkac deneme yazi yazmak istiyorum. Sonradan bu yazilarin PDF uzerinde ' +
           'nasil gorunecegini merak ediyorum.', at: [200, 500], direction: :rtl
end