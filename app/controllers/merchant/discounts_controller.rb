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

  def show 
    @discount = Discount.find(params[:id])
  end

  def edit 
    if session[:failed_update_discount]
      @discount = Discount.find(session[:failed_update_discount])
    else
      @discount = Discount.find(params[:id])
    end
  end

  def update 
    @discount = Discount.find(params[:id])
    update_discount(@discount)
  end

  def destroy
    discount = Discount.find(params[:id])
    discount.destroy 
    redirect_to "/merchant/discounts"
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

  def update_discount(discount)
    discount.update(discount_params)
    if discount.save
      flash[:discount] = 'Your discount was updated successfully'
      session[:failed_update_discount] = nil
      redirect_to '/merchant/discounts'
    else
      session[:failed_update_discount] = params[:id]
      flash[:error] = discount.errors.full_messages.to_sentence
      redirect_to "/merchant/discounts/#{params[:id]}/edit"
    end
  end

end