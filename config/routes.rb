Rails.application.routes.draw do
  root to: 'recipes#index'

  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # get '/send_reset_email', to: 'password_resets#new'
  # post '/send_reset_email', to: 'password_resets#create'
  # get '/reset_password(', to: 'password_resets#edit'
  # post '/reset_password', to: 'password_resets#update'

  resources :users
  resources :recipes do
    post :toggle_liked, on: :member
  end
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
