Rails.application.routes.draw do
  root to: "chords#index"
  devise_for :users, except: :index
  resources :songs do
    collection do
      get :search
    end
  end
  resources :chords, except: :index
  resources :likes, only: :create
  resources :practices, except: [:new, :edit, :show]
end