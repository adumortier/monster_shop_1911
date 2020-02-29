class Admin::Merchants::ItemsController < Admin::BaseController
  def index
    if session[:merchant_id]
      @merchant = Merchant.find(session[:merchant_id])
    else
      @merchant = Merchant.find(params[:merchant_id])
      session[:merchant_id] = @merchant.id
    end
  end

  def update
    merchant = Merchant.find(params[:merchant_id])
    item = Item.find(params[:id])
    item.switch_active_status
    switch_active_with_flash(item, merchant)
  end

  # def destroy
  #   require 'pry'; binding.pry
  #   merchant = Merchant.find(params[:merchant_id])
  #   item = Item.find(params[:id])
  #   Review.where(item_id: item.id).destroy_all
  #   item.destroy
  #   flash[:notice] = "#{item.name} has been deleted"
  #   redirect_to "/admin/merchants/items"
  # end

  def switch_active_with_flash(item, merchant)
    if item.active?
      flash[:success] = "#{item.name} is activated for #{merchant.name}"
    else
      flash.keep[:success] = "#{item.name} is deactivated for #{merchant.name}"
    end
    redirect_to "/admin/merchants/items"
  end

end
