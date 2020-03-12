Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "static_pages#home"
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :users, only:[:index, :show]
  resources :friend_requests, only:[:index, :create, :update, :destroy]

  resources :posts, only: [:index, :show, :create] do
    resources :likes, only: [:create, :destroy]
    resources :comments, only: :create
  end

  resources :comments, only: :destroy
end
