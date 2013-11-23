Tictactoe::Application.routes.draw do

  root to: 'games#index'

  resources :games, only: [:index, :show, :create, :update, :destroy]

end
