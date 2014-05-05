Mongo::Application.routes.draw do
  resources :reviews

  resources :products

  resources :messages do
    get :updated, on: :member
  end

  resources :dialogs do
    get :enter, on: :collection
    get :done, on: :collection
    get :exit, on: :collection
    get :insert, on: :collection
  end

  devise_for :users
  resources :users

  resources :pages do
    get :hui
  end

  resources :areas

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'lands#main'


  get 'robots' => 'export#robots'
  get 'sitemap' => 'areas#sitemap'
  get 'sitemaps' => 'export#sitemaps'
  get ':area/sitemap' => 'export#sitemap'
  get 'chat' => 'export#chat'
  get 'blogger' => 'export#blogger'


  get ':id' => 'areas#show'
  get ':id/:page' => 'areas#show'
  post 'e/inc/xxxqwer' => 'incoming#event'

  # Example of regular route:

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end
  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
