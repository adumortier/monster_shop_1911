class Merchant::DiscountsController < Merchant::BaseController

  def index 
    @discounts = current_user.merchant.discounts.order(:number_items)
  end

  def new
    if session[:failed_discount]
      @discount = Discount.new(session[:failed_discount])
    else
      @discount = Discount.new
    end
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
     if discount.valid_discount? && discount.save 
      flash[:notice] = 'Your new discount was saved'
      session[:failed_discount] = nil
      redirect_to '/merchant/discounts'
    else
      if !discount.valid_discount? 
        flash[:conflict] = 'The discount you tried to create is in conflict with existing discounts' 
      end
      discount.destroy
      session[:failed_discount] = discount_params
      flash[:error] = discount.errors.full_messages.to_sentence
      redirect_to '/merchant/discounts/new'
    end
  end

end