Rails.application.routes.draw do
  devise_for :admins
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # ルートパス(会員TOPページ)
  root 'user/homes#top'
  # 会員aboutページ
  get '/about' => 'user/homes#about', as: 'about'
  # 管理者TOPページ
  get '/admin' => 'admin/homes#top', as: 'top'

  # 管理者側各機能のルーティング
  namespace :admin do
    resources :users, only: [:index, :show, :edit, :update]
    resources :posts, only: [:index, :show, :destroy] do
      member do
        get 'like'
      end
      resources :post_comments, only: [:index, :destroy]
    end
    resources :inquiries, only: [:index, :show]
    get '/search' => 'searchs#search', as: 'search'
  end

  # 会員側のルーティング
  scope module: :user do
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
      resources :post_comments, only: [:create, :update, :destroy]
      resources :favorites, only: [:create, :destroy]
    end
    resources :inquiries, only: [:new, :create]
    get '/search' => 'searchs#search', as: 'search'
  end

end
