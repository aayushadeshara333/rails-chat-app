Rails.application.routes.draw do
  get 'user/show'
  devise_for :users
  resources :rooms do
    resources :messages
  end
  root "rooms#index"
  devise_scope :user do
    get "users", to: "devise/sessions#new"
  end
  get 'user/:id', to: "users#show", as: "user"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
