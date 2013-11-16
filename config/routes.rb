Tictactoe::Application.routes.draw do
  resources :games, only: [:index, :show, :create, :destroy]

end
