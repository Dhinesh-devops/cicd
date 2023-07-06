Rails.application.routes.draw do

  # namespace :api do
  #   namespace :v1 do
  #     devise_for :users,
  #     controllers: {
  #       sessions: 'api/v1/authentications',
  #       registrations: 'api/v1/user_registrations',
  #       passwords: 'api/v1/user_passwords'
  #     }
  #   end
  # end

  namespace :api do
    namespace :v1 do
      post '/login', :to => 'authentications#login'
      post '/register', :to => 'user_registrations#create'
      post '/forgot_password', :to => 'user_passwords#create'
      patch '/change_password', :to => 'user_passwords#update'

      # data sheets
      get '/get_sheet_details', :to => 'data_sheets#get_daily_sheet_details'
      get '/get_stock_items/:id', :to => 'data_sheets#get_daily_stock_items'
    end
  end

  devise_for :users
  devise_scope :user do
    root to: "sessions#new"
    get '/login', :to => 'sessions#new'
    post '/create_session', :to => 'sessions#create'
    get '/logout', :to => 'sessions#logout'
    get '/forgot_password', :to => 'user_passwords#new'
    post '/send_reset_password_email', :to => 'user_passwords#create'
    get '/change_password', :to => 'user_passwords#edit'
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  
  
  get '/dashboard', :to => 'dashboard#index'
  resources :data_sheets, :only => [:new, :create]
  get '/sheet_management', :to => 'sheet_management#index'

  # Defines the root path route ("/")
  # root to: "sessions#new"
end
