Rails.application.routes.draw do
  devise_for :users, :controllers => {
    :sessions => 'users/sessions',
    :registrations => 'users/registrations',
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # ゲストログイン用
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#new_guest'
  end

  # ルートパス(TOPページ)
  root 'homes#top'

  # ユーザールーティング
  resources :users, only: [:show, :edit, :update] do
    member do
      get 'withdrawal' => 'users#withdrawal_show'
      patch 'withdrawal'
      get 'post'
      get 'like'
    end
  end
  resources :posts do
    member do
      get 'like'
    end
    collection do
      get 'ranking'
      get 'comment'
    end
    resources :post_comments, only: [:create, :edit, :update, :destroy]
    resource :favorites, only: [:create, :destroy]
  end
  get '/search' => 'searchs#search', as: 'search'
end
