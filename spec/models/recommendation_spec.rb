require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Recommendation do
  
  before(:each) do
    User.all.destroy!
  	@james = User.generate(:james)
  	@joe = User.generate(:joe)	  	
  end
    
	describe "when james recommends joe" do
	  before(:each) do	    
    	@james.recommendations.create(:recommendee => @joe)
    end
    
	  it "joe is among james's recommendees" do
			@james.recommendees.should include(@joe)
		end
	
		it "james is not among joe's recommendees" do
			@joe.recommendees.should_not include(@james)
		end
		
	end

	it "a user can not recommend himself" do
	  @james.recommendations.create(:recommendee => @james)
	  @james.recommendations.last.should_not be_valid
  end
  
  describe "when james recommends joe by his name" do
    it "recommendee can be got by his name" do
      @james.recommendations.create(:recommendee_name => @joe.name)
      @james.recommendations.first.recommendee_name.should == @joe.name
    end
  end
  
  describe "when created by name" do
    it "should be successful if there is only one user with that name" do
      Recommendation.create(:user => @james, :recommendee_name => @joe.name)
      @james.recommendees.should include(@joe)
    end
    
  end
  
end
