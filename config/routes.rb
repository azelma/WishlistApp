Wishlists::Application.routes.draw do
  root 'pages#home'
  
  resources :users, only: [:new, :create, :edit, :update]
  resources :wishlists do
  	resources :memberships, except: [:show, :edit]
    resources :comments, except: [:new, :show, :index]
  end
  resources :categories, except: [:new, :create]
  resources :items, except: [:index, :show]
  patch '/additem' => 'wishlists#additem'
  patch '/removeitem' => 'wishlists#removeitem'
  post '/items/amazon' => 'items#create_from_amazon'
  resources :sessions, only: [:new, :create]
  get '/logout' =>'sessions#destroy', as: 'logout'
end
