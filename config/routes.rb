Tictactoe::Application.routes.draw do

  root to: 'games#index'

  resources :games, only: [:index, :show, :create, :update, :destroy] do
    collection do
      patch 'human_turn_1'
      patch 'human_turn_2'
      patch 'human_turn_3'
      patch 'human_turn_4'
    end
  end

end
