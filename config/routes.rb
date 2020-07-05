Rails.application.routes.draw do
  root to: "chords#index"
  devise_for :users, controllers: {sessions: 'users/sessions'}
  devise_scope :user do
    get "users/test_sign_in", to: "users/sessions#test_create"
  end
  # テストログイン用のアクションをsessionコントローラに作りたい。そのためにルーティングをしたい

  resources :songs do
    collection do
      get :search
      get :global_search
    end
  end
  resources :chords, except: :index
  resources :likes, only: [:create, :destroy]
  resources :practices, only: [:create, :destroy]
end