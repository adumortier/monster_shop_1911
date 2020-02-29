class Merchant::DiscountsController < Merchant::BaseController

  def index 
    @discounts = current_user.merchant.discounts.order(:number_items)
  end

  def new
    @discount = Discount.new
  end

  def create 
    @discount = current_user.merchant.discounts.create(discount_params)
    create_discount(@discount)
  end

  private

  def discount_params
    params.permit(:name, :number_items, :percent)
  end

  def create_discount(discount)
     if discount.save
      flash[:notice] = 'Your new discount was saved'
      session[:failed_discount] = nil
      redirect_to '/merchant/discounts'
    else
      session[:failed_discount] = discount_params
      flash[:error] = discount.errors.full_messages.to_sentence
      redirect_to '/merchant/discounts/new'
    end
  end

end