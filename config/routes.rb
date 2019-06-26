Rails.application.routes.draw do
  resources :recipes
  get 'recipe/title'
  get 'recipe/source'
  get 'recipe/ingredients'
  get 'recipe/instructions'

  root to: 'recipes#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
