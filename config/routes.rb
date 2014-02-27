Trackerapp::Application.routes.draw do

  root to: "entries#index"
  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"

  resources :sessions

  resources :entries do
    get :autocomplete_project_name, :on => :collection
  end

  namespace :admin do
    get '/', :to => redirect("/admin/users")
    resources :projects
    resources :users
  end

end
