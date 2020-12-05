Rails.application.routes.draw do
  devise_for :users
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#index"

    get "/signup", to: "users#new", as: "signup"
    get "/login", to: "sessions#new", as: "login"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy", as: "logout"
    get "/course/list", to: "user_courses#index"

    resources :users
    resources :courses
    resources :user_courses
    resources :course_lectures
    resources :complete_courses

    namespace :admin do
      root "dashboard#index"

      resources :courses
      resources :users
    end
  end
end
