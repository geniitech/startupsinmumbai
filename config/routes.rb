Rails.application.routes.draw do
  devise_for :admins
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  get 'fetch' => 'main#fetch'
  root to: 'main#home'
end