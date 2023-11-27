require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users, controllers: {  registrations: 'users/registrations' }
  authenticate :user, ->(u) { u.is_admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end

  resources :books do
    post :reserve, on: :member
  end
  resources :reservations, only: [:index, :update]

  root 'books#index'
end
