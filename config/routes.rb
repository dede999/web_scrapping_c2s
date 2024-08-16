Rails.application.routes.draw do
  get '/attempts/:task_id', to: 'attempt#index'
  root 'attempt#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
