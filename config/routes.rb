# frozen_string_literal: true

Rails.application.routes.draw do
  resources :price_captures, only: %i[index create]
  root to: 'price_captures#index'
end
