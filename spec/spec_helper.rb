require "rubygems"

# Add the local gems dir if found within the app root; any dependencies loaded
# hereafter will try to load from the local gems before loading system gems.
if (local_gem_dir = File.join(File.dirname(__FILE__), '..', 'gems')) && $BUNDLE.nil?
  $BUNDLE = true; Gem.clear_paths; Gem.path.unshift(local_gem_dir)
end

require "merb-core"
require "spec" # Satisfies Autotest and anyone else not using the Rake tasks

# this loads all plugins required in your init file so don't add them
# here again, Merb will do it for you
Merb.start_environment(:testing => true, :adapter => 'runner', :environment => ENV['MERB_ENV'] || 'test')

# load dm-sweatshop fixtures
require File.join(File.dirname(__FILE__), 'spec_fixtures')
require File.join(File.dirname(__FILE__), 'spec_populator')

Spec::Runner.configure do |config|
  config.include(Merb::Test::ViewHelper)
  config.include(Merb::Test::RouteHelper)
  config.include(Merb::Test::ControllerHelper)

end

def login(user)
  @response = request(url(:perform_login), :method => "PUT", 
    :params => { :login => user.login, :password => user.password })
end

given "there are no users" do
	User.all.destroy!
end

given "a user exists" do
  User.all.destroy!
  User.gen(:james)
end

given "an authenticated user" do
  User.all.destroy!
  james = User.gen(:james)
  response = request(url(:perform_login), :method => "PUT", :params => { :login => james.login, :password => james.password })
  response.should redirect
end

given "two users exist" do
	User.all.destroy!
	User.gen(:james)
	User.gen(:joe)
end

given "an authenticated admin user" do
  # User.all.destroy!
  admin = User.gen(:admin)
  response = request(url(:perform_login), :method => "PUT", :params => { :login => admin.login, :password => admin.password })
end

given "a user recommends another user" do
	User.all.destroy!
  Recommendation.all.destroy!
	james = User.generate(:james)
	puts "XXX james's id: #{james.id}"
	joe = User.generate(:joe)
  request(resource(james, :recommendations), :method => "POST", 
    :params => { :recommendation => {:user_id => james.id, :recommendee_id => joe.id }})
end
