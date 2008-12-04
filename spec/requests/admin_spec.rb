require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/admin/users" do
  before(:each) do
    @response = request("/admin")
  end
  
  describe "GET" do
    before(:each) do
      @response = request(url(:admin_users))
    end
    it "shows a list of all users", :given => "two users exist" do      
      @response.should be_successful
      User.all.each do |u|
        @response.should contain(u.name)
        @response.should contain(u.login)
        @response.should contain(u.email)
      end
    end
       
  end
  
end