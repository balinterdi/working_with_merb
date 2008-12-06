require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "resource(:users)" do
  
  describe "GET", :given => "an authenticated admin user" do
    before(:each) do
      @response = request(resource(:users))
    end
    #TODO: /users is routed to /admin/users so this test
    # is the same as the admin controller one, not very DRY.
    it "has a list of users" do
      User.all.each do |u|
        @response.should contain(u.name)
        @response.should contain(u.login)
        @response.should contain(u.email)
      end
      
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      User.all.destroy!
      @response = request(resource(:users), :method => "POST", 
        :params => { :user => User.generate_attributes(:james) })
    end
    
    it "redirects to resource(:users)" do
      @response.should redirect_to(resource(User.first), :message => {:notice => "user was successfully created"})
    end
    
  end
end

describe "resource(@user)" do 
  describe "DELETE" do
      
    describe "when user is not logged in" do
      it "should not be accessible for the user without logging in" do
        @response = request(resource(User.first), :method => "DELETE")
        @response.status.should == 401
      end
    end
              
    describe "when user is logged in", :given => "an authenticated user" do
      it "should redirect to the home page" do
        @response = request(resource(User.first), :method => "DELETE")
        @response.should redirect_to(url(:home))
      end
    end
    
  end
end



describe "resource(:users, :new)" do
  before(:each) do
    @response = request(resource(:users, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
		@response.should have_selector("input#user_name[type='text']")
		@response.should have_selector("input#user_email[type='text']")
		@response.should have_selector("input#user_login[type='text']")
		@response.should have_selector("input#user_password[type='password']")
		@response.should have_selector("input#user_password_confirmation[type='password']")		
		@response.should have_selector("input[type='submit']")
  end
end

describe "resource(@user, :edit)", :given => "a user exists" do

  describe "if the user is NOT logged in" do
    it "should be denied" do
      @response = request(resource(User.first, :edit))      
      @response.status.should == 401
    end
  end

  describe "if the user is logged in", :given => "an authenticated user"  do
    it "responds successfully" do
      @response = request(resource(User.first, :edit))      
      @response.should be_successful
  		user = User.first
  		@response.should have_xpath("//input[@value='#{user.login}']")
  		@response.should have_xpath("//input[@type='submit']")
    end
  end
end

describe "resource(@user)", :given => "a user exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(User.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
			@response.should contain(User.first.login)
    end
  end
  
  describe "PUT" do
    
    describe "if the user is NOT logged in" do
      it "should be denied" do
        user = User.first
        @response = request(resource(user), :method => "PUT",
          :params => { :user => {:id => user.id} })
        @response.status.should == 401
      end
    end
    
    describe "if the user is logged in", :given => "an authenticated user" do
      it "redirects to the user show action" do
        user = User.first
        @response = request(resource(user), :method => "PUT",
          :params => { :user => {:id => user.id} })
        @response.should redirect_to(resource(user))
      end
    end
    
  end
  
end
