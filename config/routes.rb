Trackerapp::Application.routes.draw do
  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"
  resources :sessions 
  root to: "home#welcome"
  resources :entries
end
