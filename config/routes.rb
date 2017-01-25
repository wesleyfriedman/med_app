Rails.application.routes.draw do
  resources :search, only: [:index, :create] do
    collection do
      get "diseases"
    end
  end
end
