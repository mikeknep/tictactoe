Tictactoe::Application.routes.draw do

  root to: 'games#index'

  resources :games, only: [:index, :show, :create, :update, :destroy]

  resources :users, only: [:new, :create, :destroy]

  get '/sessions/new' => 'sessions#new', as: 'new_session'
  post '/sessions' => 'sessions#create', as: 'sessions'
  delete '/sessions' => 'sessions#destroy', as: 'destroy_user_session'

end
