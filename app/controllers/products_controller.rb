class ProductsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :authorize!, only: [:edit, :update, :destroy]

  def index
    @products = Product.all.order('created_at DESC')
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new product_params
    @product.user = @current_user
    if @product.save
      render(plain: "Created Product #{@product.inspect}")
    else
      render :new
    end
  end

  def show
    @product = Product.find(params[:id])
    @review = Review.new
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to products_path
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update product_params
      redirect_to product_path @product
    else
      render :edit
    end
  end

  def authorize! 
    redirect_to root_path, alert: 'Not Authorized' unless can?(:crud, Product)
  end
  private

  def product_params
    # docs about params.require() https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-require
    # docs about .permit() https://api.rubyonrails.org/classes/ActionController/Parameters.html#method-i-permit
    params.require(:product).permit(:title, :description, :price, :sale_price)
  end
end
