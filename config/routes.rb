Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      post '/login', :to => 'authentications#login'
      get '/logout', :to => 'authentications#logout'
      post '/register', :to => 'user_registrations#create'
      post '/forgot_password', :to => 'user_passwords#create'
      patch '/change_password', :to => 'user_passwords#update'

      # data sheets
      get '/get_sheet_details', :to => 'data_sheets#get_daily_sheet_details'
      get '/get_stock_items', :to => 'data_sheets#get_daily_stock_items'
      get '/get_report_data', :to => 'data_sheets#get_report_data'
      put '/update_stock_status', :to => 'data_sheets#update_stock_status'

      patch '/update_new_password', :to => 'reset_passwords#update_new_password'
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
  get '/reset_password', :to => 'dashboard#reset_password'
  patch '/update_new_password', :to => 'dashboard#update_new_password'
  resources :data_sheets, :only => [:new, :create]
  resources :managers, :only => [:index, :new, :create, :edit, :update]
  get '/sheet_management', :to => 'sheet_management#index'
  get '/download_report', :to => 'sheet_management#download_report'
  post '/update_rfid_number', :to => 'data_sheets#update_rfid_number'
  delete '/delete_data_sheet', :to => 'data_sheets#delete_data_sheet'

  get '/reports', :to => 'reports#index'
  # Defines the root path route ("/")
  # root to: "sessions#new"

  match '*path' => 'errors#404', via: :all
end
