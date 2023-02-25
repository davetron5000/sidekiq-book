Rails.application.routes.draw do
  resources :orders, only: [ :new, :create, :show ]
  root "welcome#show"
end
