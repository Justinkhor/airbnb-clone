Rails.application.routes.draw do
  get 'images/destroy'

  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, controller: "clearance/sessions", only: [:create]
  resources :images, only: [:destroy]
  resources :users, controller: "users" do
    resource :password,
      controller: "clearance/passwords",
      only: [:create, :edit, :update]
  end

  get "/sign_in" => "clearance/sessions#new", as: "sign_in"
  delete "/sign_out" => "sessions#destroy", as: "sign_out"
  get "/sign_up" => "users#new", as: "sign_up"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "static#index"
  get "/auth/:provider/callback" => "sessions#create_from_omniauth"
  resources :listings do
    resources :reservations, only: [:create]
  end
  resources :reservations, only: [:destroy] do
    resources :braintree, only: [:new, :create]
  end

  get "/my_listings" => "listings#mylisting"
  get '/search', to: 'listings#search', as: 'search'

end
