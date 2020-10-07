Rails.application.routes.draw do
  resources :note_features
  get 'app/test'
  get 'static_pages/landing'
  root to: 'static_pages#landing'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :progress_notes
      get 'note_features/stats', to: 'note_features#stats'
      resources :note_features
      get 'app/test', to: 'note_features#test'
    end
  end
end
