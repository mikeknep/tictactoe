Tictactoe::Application.routes.draw do

  root to: 'games#index'

  resources :games, only: [:index, :show, :create, :destroy] do
    collection do
      patch 'human_turn_1'
    end
  end

end
