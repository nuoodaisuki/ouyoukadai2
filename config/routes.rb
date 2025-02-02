Rails.application.routes.draw do
  get "rooms/show"
  get "messages/show"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "homes#top"
  get "home/about" => "homes#about"
  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end
  devise_for :users
  resources :books, only: [:index, :show, :edit, :create, :destroy, :update] do
    collection do
      get "search", to: "books#search", as: :search
    end
    resource :favorite, only: [:create, :destroy]
    resources :post_comments, only: [:create, :destroy]
  end
  resources :users, only: [:index, :show, :edit, :update] do
    get "search" => "users#search"
    member do
      get :followings, :followers
    end
    resource :relation_ships, only: [:create, :destroy]
  end
  get "search" => "searches#search", as: "search"
  resources :rooms, only: [:create, :show]
  resources :messages, only: [:create]
  resources :groups do
    member do
      get "new_group_email" # メールフォーム表示
      post "send_group_email" # メール送信処理
      get "email_sent" # 送信完了画面
    end
  end
  resources :groups, only: [:new, :index, :show, :create, :edit, :update] do
    resource :group_users, only: [:create, :destroy]
  end
  resources :notifications, only: [:update]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
