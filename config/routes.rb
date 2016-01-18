Rails.application.routes.draw do
  root 'home#index'
  delete 'logout', to: 'home#logout'
  resources :users, only: [:create]
end
