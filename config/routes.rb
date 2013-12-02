Trackerapp::Application.routes.draw do
  root to: "home#welcome"
  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"
  resources :sessions 
  resources :entries
  resources :projects
end
