require File.join( File.dirname(__FILE__), '..', "spec_helper" )

given "james recommends joe" do
	User.all.destroy!
	@james = User.generate(:james)
	@joe = User.generate(:joe)	
	@james.recommendations.create(:recommendee => @joe)
end

describe Recommendation do
	describe "when james recommends joe", :given => "james recommends joe" do
	  it "joe is among james's recommendees" do
			@james.recommendees.should include(@joe)
		end
	
		it "james is not among joe's recommendees" do
			@joe.recommendees.should_not include(@james)
		end
	end
	
end
