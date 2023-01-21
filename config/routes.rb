Rails.application.routes.draw do
  resources :names
  root "names#index"
end
