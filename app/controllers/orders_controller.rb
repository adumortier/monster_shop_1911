class OrdersController <ApplicationController

  def new

  end

  def show
    @order = Order.find(params[:id])
  end

  def index
    @user = current_user
  end

  def create
    order = current_user.orders.create(order_params)
    create_order(order)
  end

  private

  def order_params
    params.permit(:name, :address, :city, :state, :zip)
  end

  def create_order(order)
    if order.save
      create_item_orders(order)
    else
      flash[:notice] = "Please complete address form to create an order."
      render :new
    end
  end

  def create_item_orders(order)
      cart.items.each do |item,quantity|
        order.item_orders.create({ item: item, quantity: quantity, price: item.unit_price(quantity)})
      end
      session.delete(:cart)
      flash[:notice] = "You order was created"
      redirect_to "/profile/orders"
  end
end
