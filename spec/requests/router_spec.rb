require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "Routing" do
  before do # before all
    @james = User.gen(:james)
  end
  
  it "should route to recommendations/new on /users/:user_id/recommendations/:recommendee_id/new" do
    url(:new_prefilled_user_recommendation, :user_id => 1, :recommendee_id => 2).should == "/users/1/recommendations/2/new"
  end
  
  it "should route to recommendations/create on /users/:user_id/recommendations/:recommendee_id" do
    url(:prefilled_user_recommendation, :user_id => 1, :recommendee_id => 2).should == "/users/1/recommendations/2"
  end
  
  it "should route to recommendations/new on resource(@user, :recommendations)" do
    resource(@james, :recommendations, :new).should == "/users/#{@james.id}/recommendations/new"
  end
  
end
