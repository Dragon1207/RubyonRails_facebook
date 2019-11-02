Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "static_pages#home"
  devise_for :users
  resources :users, only:[:index, :show]
  resources :friend_requests, only:[:index, :create, :update, :destroy]

  resources :posts, only: [:index, :show, :create]
end
