Siteseer::Application.routes.draw do
  resources :locations

  get 'locations/index'
 
  root to: 'locations#index'
 end
