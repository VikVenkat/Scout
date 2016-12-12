Siteseer::Application.routes.draw do
  resources :targets


  resources :locations do
    collection {post :import}
  end

  get 'locations/index'

  root to: 'locations#index'
 end
