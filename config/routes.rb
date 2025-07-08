Rails.application.routes.draw do
  devise_for :users, sign_out_via: [ :get, :delete ]
  root to: "tasks#today"

  resources :categories do
    resources :tasks, except: [ :index ]
  end

  get "/tasks/today", to: "tasks#today", as: "today_tasks"
end
