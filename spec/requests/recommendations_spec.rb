require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "resource(@user, :recommendations, :new)", :given => "a user exists" do
  
  describe "when the user is not logged in" do
    
  	before(:each) do
  		@response = request(url(:new_user_recommendation, :user_id => User.first.id))
    end

    it "should be denied" do
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
  		end
      
      describe "and there is at least one recommendation" do
        before(:each) do
          request(resource(@james, :recommendations), :method => "POST", 
            :params => { :recommendation => {:user_id => @james.id, :recommendee_id => @joe.id }})  			
    			@response = request(resource(@james, :recommendations))
  		  end
          
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
      it "should be denied" do
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
        @response = request(resource(@james, :recommendations))
        @response.body.should contain(@james.recommendations.last.recommendee.name)
      end
      
    end
    
    
  end
  
end
