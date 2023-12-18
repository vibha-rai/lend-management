Rails.application.routes.draw do
  root 'welcome#index'

  devise_for :users, path: 'users', controllers: {
    sessions: 'users/sessions/sessions',
    registrations: 'users/sessions/registrations',
    passwords: 'users/sessions/passwords'
  }

  devise_for :admins, path: 'admins', controllers: {
    sessions: 'admins/sessions/sessions',
    registrations: 'admins/sessions/registrations',
    passwords: 'admins/sessions/passwords'
  }

  resources :loans

  resources :users, only: [:index, :show] do
    member do
      get 'loan_request'
      get 'loan_form'
      get 'create_loan_request', to: 'users#create_loan_request', as: 'create_loan_request'
      get 'confirm_interest_rate/:id', to: 'users#confirm_interest_rate', as: 'confirm_interest_rate'
      get 'reject_interest_rate/:id', to: 'users#reject_interest_rate', as: 'reject_interest_rate'
      get 'repay_loan_form', to: 'users#repay_loan_form', as: 'repay_loan_form'
      get 'repay_loan/:id', to: 'users#repay_loan', as: 'repay_loan'
      get 'loan_detail/:id', to: 'users#loan_detail', as: 'loan_detail'
    end
  end

  resources :admins, only: [:index, :show] do
    member do
      get 'loan_request'
      get 'approve_loan/:id', to: 'admins#approve_loan', as: 'approve_loan'
      get 'reject_loan/:id', to: 'admins#reject_loan', as: 'reject_loan'
      get 'active_loan'
      get 'rejected_loan'
      get 'repaid_loan'
    end
  end

  # For Admins
  devise_scope :admin do
    get 'admins/sign_out', to: 'admins/sessions/sessions#destroy'
  end

  # For Users
  devise_scope :user do
    get 'users/sign_out', to: 'users/sessions/sessions#destroy'
  end

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
