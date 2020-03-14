# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :merchants do
    resources :items, only: [:new, :create]
  end

  resources :items , except: [:new, :create] do
    resources :reviews, only: [:new, :create]
  end

  get '/merchants/:merchant_id/items', to: 'merchant_items#index'

  resources :reviews, only: [:edit, :update, :destroy]

  post '/cart/:item_id', to: 'cart#add_item'
  get '/cart', to: 'cart#show'
  patch '/cart/:item_id', to: 'cart#increment_decrement'
  delete '/cart', to: 'cart#empty'
  delete '/cart/:item_id', to: 'cart#remove_item'

  resources :orders, only: [:new, :create]
  
  get '/profile/orders/:id', to: 'orders#show'

  resources :item_orders, only: :update

  namespace :merchant do
    get '/', to: 'dashboard#index'
    resources :items, only: :index
    resources :discounts, except: :update

    patch '/discounts/:id', to: 'discounts#update', as: 'update_discount' 
    
    get '/items/:id/edit', to: 'items#edit', as: 'edit_items'
    patch '/items/:id', to: 'items#update', as: 'post_items'
    post '/items', to: 'items#create', as: 'create_items'
    get '/orders/:id', to: 'orders#show'
    resources :items, only: [:new, :destroy, :update]
  end

  namespace :admin do
    get '/', to: 'dashboard#index'
    resources :users, only: [:index, :show]
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
