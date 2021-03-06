require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "reinit fixtures" do
  User.all.destroy!
  Reason.all.destroy!
  @james = User.gen(:james)
  @joe = User.gen(:joe)
  5.of { Reason.gen }  
end

describe "resource(@user, :recommendations, :new)", :given => "reinit fixtures" do
  
  describe "when the user is not logged in" do
    
    before(:each) do
      @response = request(url(:new_user_recommendation, :user_id => @james.id))
    end

    it "should be denied" do
      @response.status.should == 401
    end
  end
  
  describe "when the user is logged in" do
        
    before(:each) do
      login(@james)
    end
    
    describe "and the user to be recommended is not provided" do
          
      before(:each) do
        @response = request(url(:new_user_recommendation, :user_id => @james.id))
      end
      
      it "should have checkboxes for giving the reason for the recommendation" do
        @response.should have_selector("input[type='checkbox'][name='recommendation[reason_attributes][]']")
      end
      
      it "should have an input box to give the recommended users' name" do
        @response.should be_successful
        @response.should have_selector("input[type='text'][name='recommendation[recommendee_name]']")
      end
    end       
  end
end

describe "url(:new_prefilled_user_recommendation)", :given => "reinit fixtures" do

  before(:each) do
    login(@james)
    @response = request(url(:new_prefilled_user_recommendation, :user_id => @james.id, :recommendee_id => @joe.id))
  end

  it "should not have an input box to provide the user's name" do
    @response.should_not have_selector("input[type='text'][name='recommendation[recommendee_name]']")
  end
  
  it "should contain the name of the user about to be recommended on the page" do
    @response.should contain(@joe.name)
  end
            
end

describe "url(:prefilled_user_recommendation)", :given => "reinit fixtures" do
  before(:each) do
    @reas1, @reas2 = Reason.gen(:worked_with_him), Reason.gen(:works_in_merb_team)
    login(@james)
    @response = request(url(:prefilled_user_recommendation, :user_id => @james.id, :recommendee_id => @joe.id), :method => "POST",
                :params => {
                  :user_id => @james.id, :recommendee_id => @joe.id,
                  :recommendation => {
                    :user_id => @james.id, :recommendee_id => @joe.id,
                    :reason_attributes => [@reas1.id, @reas2.id]
                  }
                })
  end
  
  it "a POST should create a recommendation and the recommendation's reasons" do
    @response.should redirect_to(resource(@james, :recommendations))
    @james.recommendations.first.recommendee.should == @joe
    @james.recommendations.first.reasons.count.should == 2
    @james.recommendations.first.reasons.should include(@reas1)
    @james.recommendations.first.reasons.should include(@reas2)
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
        login(@james)
      end
      
      describe "and there is at least one recommendation" do
        before(:each) do
          @james.recommendations.create(:recommendee => @joe)
          @response = request(resource(@james, :recommendations))
        end
              
        it "should list the recommended users' names" do
          @james.recommendations.each do |recommendation|
            @response.should contain(recommendation.recommendee.name)
          end
        end
        
        it "should have a link to recommend another user" do
          @response.should have_selector("a[href='#{resource(@james, :recommendations, :new)}']")         
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
        login(@james)
        @response = request(resource(@james, :recommendations), :method => "POST", 
          :params => { :recommendation => { :user_id => @james.id, :recommendee_name => @joe.name }} )        
      end
      
      it "redirects to the user's recommendations with the newly recommended user on the page" do
        @response.should redirect_to(resource(@james, :recommendations))
        @response = request(resource(@james, :recommendations))
        @response.body.should contain(@james.recommendations.last.recommendee.name)
      end
      
    end
    
    
  end
  
end
