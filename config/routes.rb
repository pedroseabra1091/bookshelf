Rails.application.routes.draw do
  devise_for :users, controllers: {  registrations: 'users/registrations' }
  resources :books

  root 'books#index'
end
