require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/admin" do
  before(:each) do
    @response = request("/admin")
  end  
end

describe "/admin/users" do
  
  describe "GET", :given => "two users exist" do
    
    describe "when the user is not authenticated" do
      it "denies access to that page" do
        response = request(url(:admin_users)) 
        response.status.should == 401
      end
    end
    
    describe "when a normal user is logged in", :given => "an authenticated user" do
      it "denies access to that page" do
        response = request(url(:admin_users)) 
        response.status.should == 401
      end
    end

    describe "when an admin user is logged in", :given => "an authenticated admin user" do
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

describe "/admin/recommendations" do
  before(:each) do
    User.all.destroy!
  	@james = User.generate(:james)
  	@joe = User.generate(:joe)	  	
  end
    
  describe "GET" do
    
    describe "when the user is not authenticated" do
      it "denies access to that page" do
        response = request(url(:admin_recommendations)) 
        response.status.should == 401
      end
    end
    
    describe "when a normal user is logged in", :given => "an authenticated user" do
      it "denies access to that page" do
        response = request(url(:admin_recommendations)) 
        response.status.should == 401
      end
    end

    describe "when an admin user is logged in" do
      
      before(:each) do
        # @james.recommendations.create(:recommendee => @joe)
        User.all.destroy!
        Recommendation.all.destroy!
        SpecPopulator.populate!(:users => 5, :recommendations => 2)
      end
      
      describe "and there are recommendations", :given => "an authenticated admin user" do        
        it "shows a list of all users" do
          response = request(url(:admin_recommendations)) 
          response.should be_successful
          2.times do
            rec = Recommendation.pick
            response.body.should contain(rec.user.name)
            response.body.should contain(rec.recommendee.name)
          end
        end
      end
      
    end
       
  end
  
end