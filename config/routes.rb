Rails.application.routes.draw do
  resources :users
  resources :accounts do
    resources :quotes, only: [:new, :create, :show, :edit]
  end
  resources :sessions, only: [:new, :create] do
    delete :destroy, on: :collection
  end

  get '/' => "home#index"
  get '/book' => "home#book"

  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
