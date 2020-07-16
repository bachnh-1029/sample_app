Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    
    get "/help", to: "static_pages#help"
    get "/about", to: "static_pages#about"
    get "/contact", to: "static_pages#contact"
    get "/signup", to: "users#new"
    post "signup", to: "users#create"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    get ":id/followings", to: "followings#index", as: "followings"
    get ":id/followers", to: "followers#index", as: "followers"
    resources :relationships, only: %i(create destroy)
    resources :users, except: :new
    resources :account_activations, only: :edit
    resources :password_resets, except: %i(index show destroy)
    resources :microposts
  end
end
