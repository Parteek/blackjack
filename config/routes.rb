Rails.application.routes.draw do
  root 'home#index'
  delete 'logout', to: 'home#logout'
  resources :users, only: [:create] do
    member do
      get :stats
    end
  end
  resources :games, only: [:new, :create, :show] do
    member do
      post :player_stop
      post :dealer_stop
    end
    resources :drawn_cards, only: [:create]
  end
  get 'leaderboards', to: 'leaderboards#index'
end
