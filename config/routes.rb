MovieSeen::Application.routes.draw do
  # omniauth
  match '/auth/:provider'          => 'Root#login',          :as => 'login'
  match '/auth/:provider/callback' => 'Root#login_callback', :as => 'login_callback'
  match '/auth/failure'            => 'Root#failure'

  match 'search'                     => 'Search#seens'
  match 'search/movies'              => 'Search#movies'
  match 'search/list/:offset'        => 'Search#seens_list',  :as => 'seens_list'
  match 'search/list/movies/:offset' => 'Search#movies_list', :as => 'movies_list'
  match 'how_to_use'                 => 'Search#how_to_use'

  match '/my/:author_id/activity' => 'My#activity', :as => 'my_activity'
  match '/my/:author_id/summary'  => 'My#summary',  :as => 'my_summary'

  match 'post'           => 'Post#index', :as => 'post_index'
  match 'post/:story_id' => 'Post#story', :as => 'post_story'

  match 'about'                      => 'About#index'

  match 'ranking/seen'         => 'Ranking#seen',   :as => 'ranking_seen'
  match 'ranking/movie'        => 'Ranking#movie',  :as => 'ranking_movie'
  match 'ranking/star'         => 'Ranking#star',   :as => 'ranking_star'
  match 'ranking/wish'         => 'Ranking#wish',   :as => 'ranking_wish'
  match 'ranking/cinema'       => 'Ranking#cinema', :as => 'ranking_cinema'
  match 'ranking/detail/:kind' => 'Ranking#detail', :as => 'ranking_detail'

  get 'login'   => 'Root#login', :as => 'root_login'
  get 'logout'  => 'Root#logout'

  resources :movie, :except => [:index, :new, :edit, :show, :create, :update, :destroy] do
      get 'seens/wish_new'    => 'seens#wish_new',    :as => 'wish_new'
      get 'seens/wish_delete' => 'seens#wish_delete', :as => 'wish_delete'
    resources :seens
  end

  scope '/admin' do
    get '/'                                   => 'Admin#index',    :as => 'admin'
    get '/admin/messages/:target/:message_id' => 'Admin#messages', :as => 'admin_messages'
    resources :movies do
      resources :affiliates, :except => [:show, :index]
    end
    resources :tags
    resources :reports, :except => [:new, :show]
    resources :stories
  end

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
  # root :to => 'welcome#index'
  root :to => 'Root#index', :as => 'root'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
