# frozen_string_literal: true

Rails.application.routes.draw do
  root 'tweets#index'
  as :user do
    patch '/user/confirmation' => 'users/confirmations#update', :via => :patch, :as => :update_user_confirmation
  end

  devise_for :users, controllers: { registrations: 'users/registrations', confirmations: 'users/confirmations' }

  resource :user, only: %i[show edit update], controller: :user
  resources :tweets
end
