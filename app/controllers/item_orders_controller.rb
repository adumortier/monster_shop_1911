class ItemOrdersController < ApplicationController

  def update
    if params[:fulfill]
      fulfill
    else
      cancel
    end
  end


  private

    def fulfill
      item_order = ItemOrder.find(params[:id])
      item_order.update(status: "fulfilled")
      Item.find(item_order.item_id).decrement(:inventory, item_order.quantity).save
      flash[:notice] = "#{item_order.item.name} has been fulfilled!"
      item_order.order.status_changer
      redirect_to "/merchant/orders/#{item_order.order_id}"
    end

    def cancel
      order = Order.find(params[:id])
      item_orders = order.item_orders.all
      item_orders.each do |itemorder|
        if itemorder.status == "fulfilled"
          Item.find(itemorder.item_id).increment(:inventory, itemorder.quantity).save
          itemorder.update(status: "unfulfilled")
        end
      end
      order.update(status: 3)
      flash[:alert] = "Your order has been cancelled."
      redirect_to '/profile'
    end
end
