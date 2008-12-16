require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "resource(:users)" do
  
  describe "GET" do
    before(:each) do
      User.all.destroy!
      @james = User.gen(:james)
      @joe = User.gen(:joe)      
      @response = request(resource(:users))
    end

    it "should bring up a page with a search box for users" do
      @response.should have_selector("input[type='text'][name='user[name]']")
      @response.should have_selector("input[type='submit']")
    end
    
    describe "and a search query inputted in the search box" do
      before(:each) do
        @response = request(url(:user_search), :method => "POST", 
          :params => { :user => { :name => "J"}} )
        end
        
      it "should list users with the user inputted name as substring" do
        @response.should contain(@james.name)
        @response.should contain(@joe.name)
      end
    
      it "should have a recommendation link if the user is logged in" do
        login(@james)
        @response = request(url(:user_search), :method => "POST", 
          :params => { :user => { :name => "J"}} )
        @response.should have_selector("a[href='#{url(:new_prefilled_user_recommendation,
         :user_id => @james.id, :recommendee_id => @joe.id)}']")
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
  before(:all) do
    User.all.destroy!
    @james = User.gen(:james)
  end
  
  describe "DELETE" do
      
    describe "when user is not logged in" do
      it "should not be accessible for the user without logging in" do
        @response = request(resource(@james), :method => "DELETE")
        @response.status.should == 401
      end
    end
              
    describe "when user is logged in" do
      it "should redirect to the home page" do
        login(@james)
        @response = request(resource(@james), :method => "DELETE")
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

describe "resource(@user, :edit)" do
  before(:all) do
    User.all.destroy!
    @james = User.gen(:james)
  end
  
  describe "if the user is NOT logged in" do
    it "should be denied" do
      @response = request(resource(@james, :edit))      
      @response.status.should == 401
    end
  end

  describe "if the user is logged in" do
    it "responds successfully" do
      login(@james)
      @response = request(resource(@james, :edit))      
      @response.should be_successful
      @response.should have_selector("input[value='#{@james.name}']")
      @response.should have_selector("input[value='#{@james.email}']")
      @response.should have_selector("input[value='#{@james.blog_url}']")
      @response.should have_xpath("//input[@type='submit']")
    end
  end
end

describe "resource(@user)" do
  
  before(:all) do
    User.all.destroy!
    @james = User.gen(:james)
    @joe = User.gen(:joe)
    @admin = User.gen(:admin)
  end
  
  describe "GET" do
    before(:each) do
      @response = request(resource(@james))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
    it "should contain user's name and email address" do
      @response.should contain(@james.name)
      @response.should contain(@james.email)
    end
    
    describe "when the user is not logged in" do
      it "should not have a link to recommend this user" do
        #TODO: should express somehow that there is no new recommendation link on the page
        # the trouble is I need the logged in user id to generate the URL, but there is no
        # logged in user in this scenario
        @response.should_not have_selector("a[href='#{url(:new_prefilled_user_recommendation, :user_id => 1, :recommendee_id => 2)}']")
      end
    end
    
    describe "when the user is logged in" do
      before(:each) do
        login(@joe)
        @response = request(resource(@james))
      end
      
      it "should have a link to recommend this user" do
        @response.should have_selector("a[href='#{url(:new_prefilled_user_recommendation, :user_id => @joe.id, :recommendee_id => @james.id)}']")
      end
    end    
    
    describe "when there are recommendations" do
      before(:all) do
        @james.recommendations.create(:recommendee => @joe)
        @james.recommendations.create(:recommendee => @admin)
        @joe.recommendations.create(:recommendee => @james)
      end
      before(:each) do
        @response = request(resource(@james))
      end
      
      it "should have a list of the users this user recommended" do
        @response.should have_selector("div#recommended-users a[href='#{resource(@joe)}']")
        @response.should have_selector("div#recommended-users a[href='#{resource(@admin)}']")
      end
      it "should have a list of the users that recommended this user" do
        @response.should have_selector("div#recommended-by-users a[href='#{resource(@joe)}']")
      end
      
    end
  end
  
  describe "PUT" do
    
    describe "if the user is NOT logged in" do
      it "should be denied" do
        @response = request(resource(@james), :method => "PUT",
          :params => { :user => {:id => @james.id} })
        @response.status.should == 401
      end
    end
    
    describe "if the user is logged in" do
      before(:each) do
        login(@james)
      end
      
      it "redirects to the user show action" do
        @response = request(resource(@james), :method => "PUT",
          :params => { :user => {:id => @james.id} })
        @response.should redirect_to(url(:edit_user, :id => @james.id))
      end
    end
    
  end
  
end
