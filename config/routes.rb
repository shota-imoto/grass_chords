Rails.application.routes.draw do
  root to: "chords#index"
  devise_for :users, except: :index
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