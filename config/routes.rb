LearnRuby::Engine.routes.draw do
  root to: "dashboard#index"
  resources :lessons, only: [:show] do
    post :run, on: :member
    post :validate, on: :member
  end
end
