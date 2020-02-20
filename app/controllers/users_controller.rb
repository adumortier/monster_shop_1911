class UsersController < ApplicationController

  def new
    @user = User.new(user_params)
  end

  def create
    @user = User.create(user_params)
    if @user.valid?
      flash[:welcome] = "Welcome, #{@user.name}!"
      flash[:registered] = "You have registered successfully"
      session[:user] = @user.id
      redirect_to "/profile"
    else
      flash[:error] = "#{@user.errors.full_messages.to_sentence}"
      render :new
    end
  end

  def show
    if (session[:user])
      @user = User.find(session[:user])
    else
      render file: '/public/404'
    end
  end

  private

  def user_params
    params.permit(:name, :street_address, :city, :state, :zip_code, :email, :password, :password_confirmation)
  end


end
