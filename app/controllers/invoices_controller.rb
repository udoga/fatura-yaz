class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :edit, :update, :destroy, :print_pdf]
  before_action :set_others

  # GET /invoices
  # GET /invoices.json
  def index
    @invoices = Invoice.all
  end

  # GET /invoices/1
  # GET /invoices/1.json
  def show
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new
    @invoice.line_items.build
  end

  # GET /invoices/1/edit
  def edit
  end

  # POST /invoices
  # POST /invoices.json
  def create
    @invoice = Invoice.new(invoice_params)
    respond_to do |format|
      if @invoice.save
        format.html { redirect_to @invoice, notice: 'Fatura başarıyla oluşturuldu.' }
        format.json { render :show, status: :created, location: @invoice }
      else
        format.html { render :new }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /invoices/1
  # PATCH/PUT /invoices/1.json
  def update
    respond_to do |format|
      if @invoice.update(invoice_params)
        format.html { redirect_to @invoice, notice: 'Fatura başarıyla güncellendi.' }
        format.json { render :show, status: :ok, location: @invoice }
      else
        format.html { render :edit }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.json
  def destroy
    @invoice.destroy
    respond_to do |format|
      format.html { redirect_to invoices_url, notice: 'Fatura başarıyla silindi.' }
      format.json { head :no_content }
    end
  end

  def print_pdf
    output_file_location = "#{Rails.root}/public/output.pdf"
    @invoice.print_pdf(output_file_location)
    send_file(
      output_file_location,
      filename: "output.pdf",
      type: "application/pdf"
    )
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Invoice.find(params[:id])
    end

    def set_others
      @customers = Customer.all
      @products = Product.all
      @invoice_styles = InvoiceStyle.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invoice_params
      invoice_params = params.require(:invoice).permit(:date, :time, :tax_rate, :customer_id, :invoice_style_id,
                                      line_items_attributes: [:id, :product_id, :quantity])
      line_items_attributes = invoice_params['line_items_attributes']
      if line_items_attributes
        line_items_attributes.values.each do |line_item_attr|
          line_item_attr['_destroy'] = '1' if line_item_attr.length == 1 and line_item_attr.keys.first == 'id'
        end
      end
      invoice_params
    end
end
