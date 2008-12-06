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
    it "he is denied access" do
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
      it "he should be denied access" do
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

describe "resource(@user, :recommendations, :new)", :given => "a user exists" do
  
  describe "when the user is not logged in" do
    
  	before(:each) do
  		@response = request(url(:new_user_recommendation, :user_id => User.first.id))
    end

    it "he should be denied access" do
      @response.status.should == 401
    end
  end
  
  describe "when the user is logged in", :given => "an authenticated user" do
    
    before(:each) do
    		@response = request(url(:new_user_recommendation, :user_id => User.first.id))
      end
        
  	it "responds successfully" do
  		@response.should be_successful
  		@response.should have_xpath("//input[@type='text']")
  	end
  	
	end
end

describe "resource(@user, :recommendations)" do	
	before(:each) do
	  #TODO: replace that with User.pick(:james)
	  User.all.destroy!
		@james = User.gen(:james)
		@joe = User.gen(:joe)
  end
  
	describe "GET" do
	  
		describe "when the user is not logged in" do
  		it "should be denied if the user is not logged in" do
  		  response = request(resource(@james, :recommendations))
  		  response.status.should == 401  			
  	  end
	  end
  
    describe "when the user is logged in" do
      
  		before(:each) do
  		  @response = request(url(:perform_login), :method => "PUT", :params => { :login => @james.login, :password => @james.password })
  		  request(resource(@james, :recommendations), :method => "POST", 
          :params => { :recommendation => {:user_id => @james.id, :recommendee_id => @joe.id }})  			
  			@response = request(resource(@james, :recommendations))
  		end
      
      describe "and there is at least one recommendation" do
    		it "shows a list of the user's recommendations" do
    		  @response.should be_successful
    			@response.should have_xpath("//ul//li")
    		end
		
    		it "the list contains the names of the recommended users" do
    			@james.recommendations.each do |recommendation|
    				@response.should contain(recommendation.recommendee.name)
    			end
    		end
  		end
  	end	
	end
	
	describe "a POST to create a new recommendation" do
	  describe "when the user is not logged in" do
      before(:each) do
        @response = request(resource(@james, :recommendations), :method => "POST", 
          :params => { :recommendation => { :user_id => @james.id, :recommendee_id => @joe.id }} )
      end
      it "is denied" do
        @response.status.should == 401
      end
    end
    describe "when the user is logged in" do
      before(:each) do
  		  @response = request(url(:perform_login), :method => "PUT", :params => { :login => @james.login, :password => @james.password })
  		  @response = request(resource(@james, :recommendations), :method => "POST", 
          :params => { :recommendation => { :user_id => @james.id, :recommendee_id => @joe.id }} )        
		  end
		  
		  it "redirects to the user's recommendations with the newly recommended user on the page" do
        @response.should redirect_to(resource(@james, :recommendations))
        # the new recommendation must be there on the page
        @response = request(resource(@james, :recommendations))
        @response.body.should contain(@james.recommendations.last.recommendee.name)
      end
      
    end
    
    
  end
  
end
