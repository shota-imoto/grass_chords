Rails.application.routes.draw do
  root to: "chords#index"
  devise_for :users, controllers: {sessions: 'users/sessions', registrations: 'users/registrations'}
  devise_scope :user do
    get "users/test_sign_in", to: "users/sessions#test_create"
  end
  resources :users, only: :show do
    collection do
      get :search
    end
  end
  resources :songs, except: :index do
    collection do
      get :search
      get :global_search
      get :id_search
    end
  end
  resources :chords, except: :index
  resources :likes, only: [:create, :destroy]
  resources :practices, only: [:create, :destroy]
  resources :messages, only: [:index, :create] do
    collection do
      get :list
    end
  end

  get "informations/apply", to: "informations#apply"
  get "informations/vision", to: "informations#vision"
end
