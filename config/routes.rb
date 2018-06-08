Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  resources :users, only: [:new, :show, :edit] do
    resources :lists, only: [:new, :create, :index]
  end
  
  resources :lists, only: [:show, :edit, :update, :destroy] do
    resources :items, only: [:new, :create]
  end
  
  resources :items, only: [:show, :edit, :update, :destroy]
  
  get '/login', to: 'sessions#new'
  post '/sessions', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  
  root 'application#home'
  
end
