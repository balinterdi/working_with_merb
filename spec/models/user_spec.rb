require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe User do
	before(:each) do
		@user = User.generate
		@joe = User.generate(:joe)
	end

	# this is testing whether DM knows its ass from its elbow
	# however, it is useful since I can likewise
	# check the validity of my factory objects (gen. by dm-sweatshop)
  it "should be valid" do
		@user.should be_valid
	end

  it "'joe smith' should be valid" do
		@joe.should be_valid
	end
	
	it "with three or more name parts should be valid" do
		@user.name = 'james joyner brown'
		@user.should be_valid
	end	
	
	it "with names of less then two parts should not be valid" do
		@user.name = 'james'
		@user.should_not be_valid
	end
	
	it "with names that have a number anywhere should not be valid" do
		@user.name = 'james'
		@user.should_not be_valid
	end
	
	it "with three parts the middle of which is an initial should be valid" do
		@user.name = 'james j. brown'
		@user.should be_valid
	end
	

end