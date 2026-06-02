Rails.application.routes.draw do
  devise_for :users

  resources :users, only: [:index, :new] do
    collection do
      post :import
    end
  end

  root "users#index"
end