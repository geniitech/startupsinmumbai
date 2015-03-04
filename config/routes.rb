Rails.application.routes.draw do
  devise_for :admins
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  get 'fetch' => 'main#fetch'
  post 'submission' => 'main#submission'
  post 'submission_from_app' => 'main#organization_form_submission'
  root to: 'main#home'
end