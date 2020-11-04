Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#index"

    get "/signup", to: "users#new", as: "signup"
    get "/login", to: "sessions#new", as: "login"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy", as: "logout"
    get "/course/list", to: "user_courses#home", as: "user_course_list"
    post "/enroll", to: "user_courses#create", as: "enroll"
    get "course-lecture/next/:course_id/:number",
        to: "course_lectures#next_lecture",
        as: "next_lecture"
    get "course-lecture/previous/:course_id/:number",
        to: "course_lectures#previous_lecture",
        as: "previous_lecture"

    resources :users
    resources :courses
    resources :user_courses
    resources :course_lectures
  end
end
