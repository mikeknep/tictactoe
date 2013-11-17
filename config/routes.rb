Tictactoe::Application.routes.draw do

  root to: 'games#index'

  resources :games, only: [:index, :show, :create, :destroy] do
    collection do
      patch 'first_human_turn'
    end
  end

end
