require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe Recommendation do
  
  before do
    User.all.destroy!
  	@james = User.generate(:james)
  	@joe = User.generate(:joe)
  end

  before(:each) do
    Recommendation.all.destroy!
    Reason.all.destroy!
    @worked_with_him = Reason.gen(:worked_with_him)
    @works_in_merb_team = Reason.gen(:works_in_merb_team)      	
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
  
  describe "when a reason is given for recommendation" do
    before(:each) do
      @recommendation = Recommendation.create(:user => @james, :recommendee => @joe)
      @james.recommendations << @recommendation
      @james.recommendations.first.reasons << @worked_with_him
    end
    
    it "should be among the reasons for the recommendation" do
      @james.recommendations.first.reasons.first.should == @worked_with_him
    end    
    
  end
  
  describe "when creating reasons through the reason_attributes attribute" do
    before(:each) do
      @recommendation = Recommendation.create(:user => @james, :recommendee => @joe)
      @recommendation.reason_attributes = [@worked_with_him.id, @works_in_merb_team.id]
    end
    
    it "the new recommendation should have the given reasons associated with it" do
      @recommendation.reasons.should include(@worked_with_him)
      @recommendation.reasons.should include(@works_in_merb_team)
    end
    
    it "the recommending user should see these reasons for the recommendation" do
      # if I do not call the reason_attributes= on the local variable first,
      # it does not pass (because of var. names pointing to diff. memory addresses)
      rec = @james.recommendations.first
      rec.reason_attributes = [@worked_with_him.id, @works_in_merb_team.id]
      @james.recommendations.first.reasons.should include(@worked_with_him)
      @james.recommendations.first.reasons.should include(@works_in_merb_team)
    end
  end
  
end
