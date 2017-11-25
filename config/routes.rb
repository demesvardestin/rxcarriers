Rails.application.routes.draw do

  devise_for :pharmacies, :controllers => {:registrations => "pharmacy/registrations"}
  devise_for :drivers, :controllers => { :registrations => "driver/registrations"}
  get 'cancellation_message/create'

  get 'request_message/create'

  get 'patients/create'

  get 'batch/new', to: 'batches#new'

  get 'batch/create'

  get 'batch/destroy'
  get 'help', to: 'supports#new'
  get 'deliveries/:id/signature', to: 'deliveries#signature'
  get 'cancel-request', to: 'requests#cancel'
  get 'driver/requests', to: 'drivers#requests'
  get 'settings', to: 'pharmacies#edit'
  get 'driver/:id/settings', to: 'drivers#edit'
  get 'driver/:id/settings/car-info', to: 'drivers#edit'
  get 'driver/:id/settings/account-info', to: 'drivers#edit'
  get 'driver/:id/settings/advanced', to: 'drivers#edit'
  get 'settings/advanced', to: 'pharmacies#edit'
  get 'settings/password', to: 'pharmacies#edit'
  get 'settings/account-info', to: 'pharmacies#edit'
  get 'settings/billing-info', to: 'pharmacies#edit'
  get 'batches/packages', to: 'batches#index'
  get 'batches/pharmacist', to: 'batches#index'
  get 'batches/pending', to: 'batches#index'
  get 'batches/accepted', to: 'batches#index'
  get 'batches/completed', to: 'batches#index'
  get 'batch_search', to: 'batches#index'
  get 'patient/search', to: 'patients#index'
  get 'request/search', to: 'requests#index'
  get 'pharmacy/search', to: 'pharmacies#index'
  get 'pharmacy/:id/settings', to: 'pharmacies#edit', as: "account_settings"
  get 'transactions', to: 'invoices#index'
  get 'users/auth/stripe_connect/callback', to: 'charges#stripe'
  get 'requests/:id', to: 'requests#show'
  get 'patients', to: 'patients#index'
  get 'requests', to: 'requests#index'
  get 'request_driver', to: 'batches#request_driver'
  get 'batches', to: 'batches#index'
  get 'my-earnings', to: 'drivers#transactions'
  get 'home', to: 'drivers#show'
  get 'my-deliveries', to: 'drivers#deliveries'
  get 'pharmacy/view', to: 'pharmacies#index'
  post 'welcome/sms/reply', to: 'batches#driver_response'
  resources :patients, only: [:new, :create, :show, :edit, :delete]
  resources :supports
  resources :charges
  resources :drivers
  resources :pharmacies do
    
  end
  resources :deliveries
  resources :batches do
    resources :deliveries
  end
  resources :cancellation_messages
  resources :request_messages
  authenticated :driver do
    root 'drivers#requests', as: :authenticated_driver_root
  end
  authenticated :pharmacy do
    root 'batches#index', as: :authenticated_pharmacy_root
  end
  root 'pharmacies#index'
  # The priority is based upon order of creation: first created -> highest priority.
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
