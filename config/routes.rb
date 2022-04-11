Rails.application.routes.draw do
  resources :profiles, only: [:index, :show]
  devise_for :users

  root "home#index"
end
