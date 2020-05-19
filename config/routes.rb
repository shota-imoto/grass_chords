Rails.application.routes.draw do
  root to: "chords#index"
  resources :contact, only: :index
  resources :pdf, only: :new
  devise_for :users, except: :index
  resources :songs do
    collection do
      get :search
      get :search_page
      get :search_detail
    end
  end
  resources :chords, except: :index
  resources :scores
  resources :practices, except: [:new, :edit, :show]
  resources :instruments, except: :index do
    collection do
      get :search
    end
  end
  resources :keys, only: :create
  resources :tuning_alls, except: :show do
  end
  resources :tuning_all_form, only: [:new, :create]
  resources :finger_alls, except: :show
end
