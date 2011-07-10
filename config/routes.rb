Openmedia::Application.routes.draw do

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  devise_for :admins

  match '/admin' => 'admin/home#index', :as => :admin_root
  match '/about' => 'admin/home#about', :as => :about
  match '/support' => 'admin/home#support', :as => :support

#  root :to => "public/collections#index"
  root :to => "public/welcome#index"
  
  scope :module => 'public' do
    resources :sites do
      collection do
        get :autocomplete_geoname
      end
    end
    resources :collections
    resources :classes
    resources :maps
    resources :dashboards
    resources :welcome do
      collection do
        get :license
      end
    end
  end
  
  namespace :admin do
    resource :site
    resource :community
    resources :dashboards do
      collection do
        get :new_group
        get :new_measure
      end
    end
    resources :maps
    
    namespace :om_linked_data do
      resources :collections do
        resources :vocabularies do
          resources :types
          resources :properties
        end
      end
    end

    namespace :schema do
      resources :collections do
        resources :classes
      end
      resources :classes do
        collection do
          get :new_property
          get :autocomplete
          get :property_list
        end
      end
    end    
    
    resources :datasources do
      collection do
        get :new_property
      end

      member do
        get :raw_records
        get :publishing
        put :publish
      end
    end
    
    resources :catalogs
    resources :properties
    resources :settings
    resources :reports
    resources :vcards
    resources :contacts
    resources :schedules
    resources :data_types
  end

  # resource :account, :to=>"users"
  # resources :users
  # resources :user_sessions

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
