require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe User do
	before(:each) do
		@user = User.generate
		@joe = User.generate(:joe)
	end

	# this is testing whether DM knows its ass from its elbow
	# however, it is useful since I can likewise
	# check the validity of my factory objects (gen. by dm-sweatshop)
  it "one should be valid" do
		@user.should be_valid
	end

  it "joe smith should be valid" do
		@joe.should be_valid
	end

end