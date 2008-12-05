require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/admin/users" do
  before(:each) do
    @response = request("/admin")
  end
  
  describe "GET", :given => "two users exist" do
    before(:each) do
      @response = request(url(:admin_users))
    end
    
    describe "the user is not authenticated" do
      it "denies access to that page" do
        response = request(url(:admin_users)) 
        response.status.should == 401
      end
    end
    
    describe "a normal user is logged in", :given => "an authenticated user" do
      it "denies access to that page" do
        response = request(url(:admin_users)) 
        response.status.should == 401
      end
    end

    describe "an admin user is logged in", :given => "an authenticated admin user" do
      it "shows a list of all users" do
        response = request(url(:admin_users)) 
        response.should be_successful
        User.all.each do |u|
          response.should contain(u.name)
          response.should contain(u.login)
          response.should contain(u.email)
        end
      end
    end
       
  end
  
end