Rails.application.routes.draw do

  resources :problem_solvings do
    collection do
      get :recent
      get 'month/:year/:month' => 'problem_solvings#month'
    end
  end

  resources :reframings do
    collection do
      get :recent
      get 'month/:year/:month' => 'reframings#month'
    end
  end

  get 'api_docs/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :self_cares

  get 'api-docs', to: 'api_docs#index'
end
