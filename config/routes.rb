Rails.application.routes.draw do
  get 'password_resets/new'

  get 'password_resets/edit'

  get 'users/new'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/logout', to: 'static_pages#home'
  patch '/update', to: 'users#update'
 

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'static_pages#home'

  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:edit, :new, :create, :update]
  resources :microposts, only: [:create, :destroy, :edit, :update]
end
