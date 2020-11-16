Rails.application.routes.draw do

  devise_for :users, :controllers => {
    :sessions => 'users/sessions',
    :registrations => 'users/registrations'

  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # ルートパス(TOPページ)
  root 'homes#top'

  # ユーザールーティング
  resources :users, only: [:show, :edit, :update] do
    member do
      get 'withdrawal' => 'users#withdrawal_show'
      patch 'withdrawal'
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
    resources :post_comments, only: [:create, :update, :destroy]
    resources :favorites, only: [:create, :destroy]
  end
  get '/search' => 'searchs#search', as: 'search'

end
