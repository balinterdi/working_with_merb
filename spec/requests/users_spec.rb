require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a user exists" do
  User.all.destroy!
  request(resource(:users), :method => "POST", 
    :params => { :user => User.gen_attrs(:james) })
end

given "there are no users" do
	User.all.destroy!
end

given "two users exist" do
	User.all.destroy!
  request(resource(:users), :method => "POST", 
    :params => { :user => User.gen_attrs(:james) })
  request(resource(:users), :method => "POST", 
    :params => { :user => User.gen_attrs(:joe) })
end

given "a user recommends another user" do
	User.all.destroy!
  Recommendation.all.destroy!
	james = User.generate(:james)
	joe = User.generate(:joe)
  request(resource(james, :recommendations), :method => "POST", 
    :params => { :recommendation => {:user_id => james.id, :recommendee_id => joe.id }})
end


describe "resource(:users)" do
  describe "GET", :given =>"there are no users" do
    
    before(:each) do
      @response = request(resource(:users))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "shows an empty page with no users" do
			@response.should have_xpath("//div[@id='user_list']")
      @response.should_not have_xpath("//div//div[@class='user_row']")
    end
    
  end
  
  describe "GET", :given => "a user exists" do
    before(:each) do
			@joe = User.generate(:joe)
      @response = request(resource(:users))
    end
    
    it "has a list of users" do
	    @response.should be_successful
	 		@response.should contain(User.first.login)
		 	@response.should contain(User.first(:login => @joe.login).login)
			@response.should have_xpath("//div//div[@class='user_row']")
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
  describe "a successful DELETE", :given => "a user exists" do
     before(:each) do
       @response = request(resource(User.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:users))
     end

   end
end

describe "resource(:users, :new)" do
  before(:each) do
    @response = request(resource(:users, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
		@response.should contain("Login")
		@response.should contain("Password")
		@response.should contain("Password again")
		@response.should have_xpath("//input[@type='submit']")
  end
end

describe "resource(@user, :edit)", :given => "a user exists" do
  before(:each) do
    @response = request(resource(User.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
		user = User.first
		@response.should have_xpath("//input[@value='#{user.login}']")
		@response.should have_xpath("//input[@type='submit']")
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
    before(:each) do
      @user = User.first
      @response = request(resource(@user), :method => "PUT", 
        :params => { :user => {:id => @user.id} })
    end
  
    it "redirect to the user show action" do
      @response.should redirect_to(resource(@user))
    end
  end
  
end

describe "resource(@user, :recommendations, :new)", :given => "a user exists" do
	before(:each) do
    # @response = request(resource(User.first, :recommendations, :new))
		@response = request(url(:new_user_recommendation, :user_id => User.first.id))
  end
  
	it "responds successfully" do
		@response.should be_successful
		@response.should have_xpath("//input[@type='text']")
	end
end

describe "resource(@user, :recommendations)" do	
	
	describe "GET", :given => "a user recommends another user" do
		
		before(:each) do
			@james = User.first(:login => 'james_duncan')
			@response = request(resource(User.first, :recommendations))
		end
		
		it "shows a list of the user's recommendations" do
			@response.should have_xpath("//ul//li")
		end
		
		it "the list contains the names of the recommended users" do
			@james.recommendations.each do |recommendation|
				@response.should contain(recommendation.recommendee.name)
			end
		end
		
	end
	
end
