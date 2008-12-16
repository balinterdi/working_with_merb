require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/admin" do
  before(:each) do
    @response = request("/admin")
  end  
end

describe "/admin/users" do
  
  before(:each) do
    User.all.destroy!
    @james = User.generate(:james)
    @joe = User.generate(:joe)
    @admin = User.generate(:admin)
  end
  
  describe "GET" do
    
    describe "when the user is not authenticated" do
      it "denies access to that page" do
        response = request(url(:admin_users)) 
        response.status.should == 401
      end
    end
    
    describe "when a normal user is logged in" do
      before(:each) do
        login(@james)
        @response = request(url(:admin_users))
      end
      it "he should be denied access to the page" do
        @response.status.should == 401
      end
    end

    describe "when an admin user is logged in" do
      before(:each) do
        login(@admin)
        @response = request(url(:admin_users)) 
      end
      
      it "should show a list of all users" do
        @response.should be_successful
        User.all.each do |u|
          @response.should contain(u.name)
          @response.should contain(u.login)
          @response.should contain(u.email)
        end
      end
    end
       
  end
  
end

describe "/admin/recommendations" do
  before(:each) do
    User.all.destroy!
    @james = User.generate(:james)
    @joe = User.generate(:joe)
  end
    
  describe "GET" do
        
    describe "when the user is not authenticated" do
      before(:each) do
        response = request(url(:admin_recommendations)) 
      end
      
      it "he should be denied access to the page" do
        response.status.should == 401
      end
    end
    
    describe "when a normal user is logged in" do
      before(:each) do
        login(@james)
        response = request(url(:admin_recommendations)) 
      end
      
      it "he should be denied access to the page" do
        response.status.should == 401
      end
    end

    describe "when an admin user is logged in" do
      
      before(:each) do
        User.all.destroy!
        Recommendation.all.destroy!
        SpecPopulator.populate!(:users => 8, :recommendations => 5)
        @admin = User.generate(:admin)
        login(@admin)
        @response = request(url(:admin_recommendations))
      end
      
      it "should show a list of all recommendations" do
        @response.should be_successful
        2.times do
          rec = Recommendation.pick
          @response.body.should contain(rec.user.name)
          @response.body.should contain(rec.recommendee.name)
        end
      end
      
    end
       
  end
  
end