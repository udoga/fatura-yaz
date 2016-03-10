class InvoiceStylesController < ApplicationController
  def index
    @invoice_styles = InvoiceStyle.all
  end

  def new
    @invoice_style = InvoiceStyle.new
  end

  def edit
    @invoice_style = InvoiceStyle.find(params[:id])
  end

  def show
    @invoice_style = InvoiceStyle.find(params[:id])
    render 'edit'
  end

  def update
    @invoice_style = InvoiceStyle.find(params[:id])
    if @invoice_style.update(invoice_style_params)
      redirect_to invoice_styles_path, notice: 'Fatura başarıyla güncellendi.'
    else
      render 'edit'
    end
  end

  def create
    @invoice_style = InvoiceStyle.new(invoice_style_params)
    if @invoice_style.save
      redirect_to invoice_styles_path, notice: 'Fatura şablonu başarıyla oluşturuldu.'
    else
      render 'new'
    end
  end

  def destroy
    @invoice_style = InvoiceStyle.find(params[:id])
    @invoice_style.destroy
    redirect_to invoice_styles_path, notice: 'Fatura şablonu başarıyla silindi.'
  end

  private
  def invoice_style_params
    params.require(:invoice_style).permit(:name, :style_content)
  end
end
