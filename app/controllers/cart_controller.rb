class CartController < ApplicationController
  before_action :exclude_admin

  def add_item
    item = Item.find(params[:item_id])
    if (cart.contents[item.id.to_s].nil? && (item.inventory != 0)) 
      cart.add_item(item.id.to_s)
      flash[:success] = "#{item.name} was successfully added to your cart"
    elsif (cart.contents[item.id.to_s] < item.inventory) 
      cart.add_item(item.id.to_s)
      flash[:success] = "#{item.name} was successfully added to your cart"
    end
    redirect_to "/items" 
  end

  def show
    @items = cart.items
  end

  def empty
    session.delete(:cart)
    redirect_to '/cart'
  end

  def remove_item
    session[:cart].delete(params[:item_id])
    redirect_to '/cart'
  end

  def exclude_admin
    render file: "/public/404", status: 404 if current_admin
  end

  def increment_decrement
    if params[:increment_decrement] == "increment"
      cart.add_quantity(params[:item_id]) unless cart.limit_reached?(params[:item_id])
    elsif params[:increment_decrement] == "decrement"
      cart.subtract_quantity(params[:item_id])
      return remove_item if cart.quantity_zero?(params[:item_id])
    end
    redirect_to "/cart"
  end
end
