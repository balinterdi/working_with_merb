require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "Routing" do
  it "should route to recommendations/index on /users/(:id)/recommendations/new/(:recc_id)" do
    url(:prefilled_user_recommendation, :user_id => 1, :recommendee_id => 2).should == "/users/1/recommendations/new/2"
  end
end
