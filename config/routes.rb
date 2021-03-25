Rails.application.routes.draw do
  root 'home#index'

  match '/search', to: 'home#search', via: :get
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
