Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'cocktails#index'

  resources :cocktails do
    resources :doses, only:[:new, :create, :destroy], shallow: true
  end

  post 'cocktails/search', to: 'cocktails#search'

  get 'cocktails/search/:query', to: 'cocktails#add', as: :cocktails_add

end
