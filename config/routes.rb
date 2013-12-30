Tictactoe::Application.routes.draw do

  root to: 'sessions#new'

  resources :games, only: [:index, :show, :create, :update, :destroy]

  resources :users, except: [:index]

  get '/sessions/new' => 'sessions#new', as: 'new_session'
  post '/sessions' => 'sessions#create', as: 'sessions'
  delete '/sessions' => 'sessions#destroy', as: 'destroy_user_session'

end
