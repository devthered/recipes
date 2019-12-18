Rails.application.routes.draw do
  root to: 'recipes#index'
  get '/saved_recipes', to: 'users#index_saved_recipes'

  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users
  resources :recipes do
    post :toggle_saved, on: :member
  end

  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]

  default_url_options :host => "example.com"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
