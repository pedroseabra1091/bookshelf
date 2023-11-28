require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users, controllers: {  registrations: 'users/registrations' }
  authenticate :user, -> (u) { u.is_admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end

  resources :books do
    post :reserve, on: :member
  end
  resources :reservations, only: %i[index show update]
  resources :company_reservations, only: [:index], path: 'company-reservations'

  root 'books#index'
end
