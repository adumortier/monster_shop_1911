# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/merchants', to: 'merchants#index'
  get '/merchants/new', to: 'merchants#new'
  get '/merchants/:id', to: 'merchants#show'
  post '/merchants', to: 'merchants#create'
  get '/merchants/:id/edit', to: 'merchants#edit'
  patch '/merchants/:id', to: 'merchants#update'
  delete '/merchants/:id', to: 'merchants#destroy'

  get '/items', to: 'items#index'
  get '/items/:id', to: 'items#show'
  get '/items/:id/edit', to: 'items#edit'
  patch '/items/:id', to: 'items#update'
  get '/merchants/:merchant_id/items', to: 'merchant_items#index'

  get '/merchants/:merchant_id/items/new', to: 'items#new'
  post '/merchants/:merchant_id/items', to: 'items#create'
  delete '/items/:id', to: 'items#destroy'

  get '/items/:item_id/reviews/new', to: 'reviews#new'
  post '/items/:item_id/reviews', to: 'reviews#create'

  get '/reviews/:id/edit', to: 'reviews#edit'
  patch '/reviews/:id', to: 'reviews#update'
  delete '/reviews/:id', to: 'reviews#destroy'

  post '/cart/:item_id', to: 'cart#add_item'
  get '/cart', to: 'cart#show'
  patch '/cart/:item_id', to: 'cart#increment_decrement'
  delete '/cart', to: 'cart#empty'
  delete '/cart/:item_id', to: 'cart#remove_item'

  get '/orders/new', to: 'orders#new'
  post '/orders', to: 'orders#create'
  get '/profile/orders/:id', to: 'orders#show'

  patch '/item_orders/:item_order_id', to: 'item_orders#update'

  namespace :merchant do
    get '/', to: 'dashboard#index'
    get '/items', to: 'items#index'
    get '/discounts', to: 'discounts#index'
    get '/discounts/:id', to: 'discounts#show'
    post '/discounts', to: 'discounts#create'
    get '/discounts/new', to: 'discounts#new'
    get '/items/:id/edit', to: 'items#edit', as: 'edit_items'
    patch '/items/:id', to: 'items#update', as: 'post_items'
    post '/items', to: 'items#create', as: 'create_items'
    get '/orders/:id', to: 'orders#show'
    get '/items/new', to: 'items#new'
    delete '/items/:id', to: 'items#destroy'
    patch '/items/:id', to: 'items#update'
  end

  namespace :admin do
    get '/', to: 'dashboard#index'
    get '/users', to: 'users#index'
    get '/users/:user_id', to: 'users#show'
    get '/users/:user_id/orders/:order_id', to: 'orders#show'
    get '/merchants', to: 'merchants/merchants#index'
    get '/merchants/items', to: 'merchants/items#index'
    get '/merchants/:id', to: 'merchants/merchants#show'
    patch '/merchants/:id', to: 'merchants/merchants#update'
    delete '/merchants/items/:id', to: 'merchants/items#destroy'
    patch '/merchants/items/:id', to: 'merchants/items#update'
    patch '/orders/:order_id', to: 'orders#update'
  end

  get '/register', to: 'users#new'
  post '/users', to: 'users#create'
  get '/profile', to: 'users#show'
  get '/profile/edit', to: 'users#edit'
  patch '/profile', to: 'users#update'

  get '/', to: 'welcome#index'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get '/user/password/edit', to: 'users_password#edit'
  patch '/user/password/update', to: 'users_password#update'

  get '/profile/orders', to: 'orders#index'


end
