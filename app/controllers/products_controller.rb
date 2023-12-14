class ProductsController < ApplicationController
  before_action :load_resources

  def index; end

  def show; end

  def new; end

  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to product_url(@product), notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to product_url(@product), notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product.destroy

    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def load_resources
    if action == :index
      # Load all products as there's no specific requirement
      @products = Product.all
    elsif action == :new
      @products = Product.new
    else
      # lax id lookup for now.
      @product = Product.find_by(id: params[:id])
    end
  end

  def product_params
    params.require(:product).permit(:code, :name, :price)
  end
end
