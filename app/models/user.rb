# This is a default user class used to activate merb-auth.  Feel free to change from a User to 
# Some other class, or to remove it altogether.  If removed, merb-auth may not work by default.
#
# Don't forget that by default the salted_user mixin is used from merb-more
# You'll need to setup your db as per the salted_user mixin, and you'll need
# To use :password, and :password_confirmation when creating a user
#
# see merb/merb-auth/setup.rb to see how to disable the salted_user mixin
# 
# You will need to setup your database and create a user.
class User
  include DataMapper::Resource
  
  property :id,     Serial
  property :login,  String, :nullable => false, :length => (4..50)
  property :email,	String, :nullable => false, :format => :email_address, :length => (1..200)
	property :blog_url, String, :format => :url
  property :role, String, :nullable => false, :default => "user" 
	property :name, String, :nullable => false, :length => (2..100), :format => /^[[:alpha:]]+\s+[[:alpha:]]+(\.?\s+[[:alpha:]]+)*$/

	has 0..n, :recommendations
	has 0..n, :recommendees, :through => :recommendations, :class_name => "User", :child_key => [:user_id]
	has 0..n, :recommended_by, :through => :recommendations, :class_name => "User", :child_key => [:recommendee_id], :remote_name => :user
	
	def admin?
	 role == "admin"
	end
	
	def set_admin
	  self.role = "admin"
  end
  
  def self.all_by_name_portion(name)
    User.all(:name.like => "%#{name}%")
  end
end
