Rails.application.routes.draw do
  get 'tasks/scheduled' => 'tasks#scheduled'

  resources :tasks, only: [:index, :create, :update, :destroy]
  resources :users, only: [:create]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
