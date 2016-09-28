Rails.application.routes.draw do
  get 'tasks/scheduled' => 'tasks#scheduled'

  # Routes for oauth2 through google
  get '/oauth2authorize' => 'authentication#oauth2authorize'
  get '/oauth2callback'  => 'authentication#oauth2callback'

  resources :tasks, only: [:index, :create, :update, :destroy]
  resources :users, only: [:create]
end
