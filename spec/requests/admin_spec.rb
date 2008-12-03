require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/admin" do
  before(:each) do
    @response = request("/admin")
  end
  
  describe "has a list of users" do
    before(:each) do
      @response = request(url(:admin_users), :method => :get)
    end
    it "shows a list of all users" do
      pending
      @response.should be_successful
      @response.should contain("admin_users_index")
    end
  end
  
end