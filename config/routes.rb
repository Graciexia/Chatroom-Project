Rails.application.routes.draw do

  get '/rooms/all/:room', to: 'rooms#get_room'

  get '/rooms/get_time/:display_range_seconds', to: 'rooms#get_time'

  get '/rooms/get_time', to: 'rooms#get_time'

  get('/rooms/:user', {to: 'rooms#show' })

  get '/rooms', to: 'rooms#index'

  post '/rooms', to: 'rooms#create'

  get 'top_user', to: 'rooms#top_user'

  get 'top_room', to: 'rooms#top_room'

  get 'chatted_recently/:display_range_seconds', to: 'rooms#chatted_recently'

  get 'chatted_recently', to: 'rooms#chatted_recently'

  get 'get_history/:start_date/:end_date', to: 'rooms#get_history'

  get '*path', to: 'rooms#show_error'

  get '/', to: 'rooms#show_error'


  # The priority is bas ed upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

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
