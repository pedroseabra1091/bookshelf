Rails.application.routes.draw do
  devise_for :users, controllers: {  registrations: 'users/registrations' }
  resources :books do
    post :reserve, on: :member
  end

  root 'books#index'
end
