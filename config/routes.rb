Rails.application.routes.draw do                                             
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  resources :users, only: [:new, :create, :show, :edit, :update] do
    resources :lists, only: [:new, :index, :edit]
  end
  
  resources :lists, only: [:new, :create, :show, :edit, :update, :destroy] do
    resources :items, only: [:new, :edit]
  end
  
  resources :items, only: [:new, :create, :show, :edit, :update, :destroy]
  
  get '/login', to: 'sessions#new'
  post '/sessions', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  
  get '/lists/:id/show-complete', to: 'lists#show'
  get '/users/:user_id/lists/show-urgent', to: 'lists#index'
  get '/users/:id/show-urgent', to: 'users#show'
  
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: redirect('/login')
  
  root 'application#home'
  
end
