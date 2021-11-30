Rails.application.routes.draw do

  resources :abcs do
    collection do
      post :import
    end
  end
  resources :faros do
    collection do
      post :import
    end
  end

  devise_for :users, controllers: {registrations: "registrations"}

  root to: 'visitors#index'

  resources :products do
    collection do
      get :import_product
      get :syncronaize
      get :export_csv
    end
  end

  resources :viistors, only: [:index] do
    collection do
      get :manual
      get :mail_test
    end
  end

end
