Rails.application.routes.draw do
  root to: "chord#index"
  devise_for :users, except: :index
  resources :songs
  resources :chords
  resources :scores
  resources :practices, except: [:new, :edit, :show]
  resources :instruments, except: :index
  resources :tuning_alls, except: :show
  resources :finger_alls, except: :show
end
