Rubydojo::Engine.routes.draw do
  root to: "dashboard#index"
  get "assets/application.css", to: "assets#css", as: :stylesheet
  resources :lessons, only: [:show] do
    post :run, on: :member
    post :validate, on: :member
  end
end
