Rails.application.routes.draw do
  root to: "chords#index"
  resources :contact, only: :index
  resources :pdf, only: :new
  devise_for :users, except: :index
  resources :songs do
    collection do
      get "search"
    end
  end
  resources :chords, except: :index
  resources :scores
  resources :practices, except: [:new, :edit, :show]
  resources :instruments, except: :index
  resources :tuning_alls, except: :show
  resources :finger_alls, except: :show
end
