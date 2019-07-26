Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'cocktails#index'

  get 'cocktails/query', to: 'cocktails#search', as: :cocktails_search

  resources :cocktails do
    resources :doses, only:[:new, :create, :destroy], shallow: true
  end


  get 'cocktails/search/:search', to: 'cocktails#add', as: :cocktails_add

end
