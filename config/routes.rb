Rails.application.routes.draw do

  resources :problem_solvings do
    collection do
      get :recent
      get 'month/:year/:month' => 'problem_solvings#month'
      post :init
      put 'done/:id' => 'problem_solvings#done'
      put 'doing/:id' => 'problem_solvings#doing'
    end
  end

  resources :reframings do
    collection do
      get :recent
      get 'month/:year/:month' => 'reframings#month'
      post :init
    end
  end

  resources :self_cares do
    collection do
      get :recent
      get 'month/:year/:month' => 'self_cares#month'
    end
  end

  resources :self_care_classifications, :only => [:update, :create]

  get 'api_docs/index'
  get 'api-docs', to: 'api_docs#index'
end
