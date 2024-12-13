# frozen_string_literal: true

Rails.application.routes.draw do
  root 'tweets#index'
  as :user do
    patch '/user/confirmation' => 'users/confirmations#update', :via => :patch, :as => :update_user_confirmation
  end

  devise_for :users, controllers: { registrations: 'users/registrations', confirmations: 'users/confirmations' }

  resources :users, only: :show do
    resources :tweets, only: :index, controller: 'users/tweets'
  end
  resource :user, only: %i[edit update], controller: :user, as: :update_user
  resources :tweets do
    resources :likes, only: :create
  end
  resources :likes, only: :destroy
end
