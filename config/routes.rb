Rails.application.routes.draw do
  root 'home#index'
  delete 'logout', to: 'home#logout'
  resources :users, only: [:create] do
    get :stats
  end
  resources :games, only: [:new, :create, :show]
end
