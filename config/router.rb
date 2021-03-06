# Merb::Router is the request routing mapper for the merb framework.
#
# You can route a specific URL to a controller / action pair:
#
#   match("/contact").
#     to(:controller => "info", :action => "contact")
#
# You can define placeholder parts of the url with the :symbol notation. These
# placeholders will be available in the params hash of your controllers. For example:
#
#   match("/books/:book_id/:action").
#     to(:controller => "books")
#   
# Or, use placeholders in the "to" results for more complicated routing, e.g.:
#
#   match("/admin/:module/:controller/:action/:id").
#     to(:controller => ":module/:controller")
#
# You can specify conditions on the placeholder by passing a hash as the second
# argument of "match"
#
#   match("/registration/:course_name", :course_name => /^[a-z]{3,5}-\d{5}$/).
#     to(:controller => "registration")
#
# You can also use regular expressions, deferred routes, and many other options.
# See merb/specs/merb/router.rb for a fairly complete usage sample.

Merb.logger.info("Compiling routes...")
Merb::Router.prepare do
  # RESTful routes
  # resources :recommendations, :keys => [:user_id, :recommendee_id]
  match("/recommendations", :method => :get).to(:controller => "admin/recommendations")
  match("/users/search").to(:controller => :users, :action => :index).name(:user_search)
  match("/users/user_name_search").to(:controller => "users", :action => "user_name_search")
  
  # TODO probably the below two can be DRY-ed with a nested structure
  match("/users/:user_id/recommendations/(:recommendee_id)/new", :recommendee_id => /\d+/).
    to(:controller => "recommendations", :action => "new").name(:new_prefilled_user_recommendation)
  match("/users/:user_id/recommendations/(:recommendee_id)", :recommendee_id => /\d+/).
    to(:controller => "recommendations", :action => "create").name(:prefilled_user_recommendation)
    
  resources :users
  resources :recommendations
  resources :users do |users|
    users.resources :recommendations
  end

	# admin routes
  namespace :admin do |admin|
    admin.resources :users
    admin.resources :recommendations
  end
  
  # r.namespace :admin do |admin|
  #   admin.resource :configurations
  #   admin.resources :dashboard
  #   admin.resources :categories
  #   admin.resources :plugins
  #   admin.resources :articles
  #   admin.match("").to(:controller => "dashboard", :action => "index")
  # end  
  
  # Adds the required routes for merb-auth using the password slice
  slice(:merb_auth_slice_password, :name_prefix => nil, :path_prefix => "")

  match("/").to(:controller => "home", :action => "index").name("home")

  # This is the default route for /:controller/:action/:id
  # This is fine for most cases.  If you're heavily using resource-based
  # routes, you may want to comment/remove this line to prevent
  # clients from calling your create or destroy actions with a GET
  default_routes
  
  # Change this for your home page to be available at /
  # match('/').to(:controller => 'whatever', :action =>'index')
	# match('/').to(:controller => 'posts', :action => 'index')
end