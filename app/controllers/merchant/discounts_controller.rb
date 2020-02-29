class Merchant::DiscountsController < Merchant::BaseController

  def index 
    @discounts = current_user.merchant.discounts.order(:number_items)
  end

end