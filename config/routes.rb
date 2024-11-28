Rails.application.routes.draw do
  get 'rooms/show'
  get 'messages/show'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root :to =>"homes#top"
  get "home/about"=>"homes#about"
  devise_for :users
  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resource :favorite, only: [:create, :destroy]
    resources :post_comments, only: [:create, :destroy]
  end
  resources :users, only: [:index,:show,:edit,:update] do
    member do
      get :followings, :followers
    end
    resource :relation_ships, only: [:create,:destroy]
  end
  get "search" => "searches#search", as: "search"
  resources :rooms, only: [:create, :show]
  resources :messages, only: [:create]
  resources :groups, only: [:new, :index, :show, :create, :edit, :update]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
