require File.join( File.dirname(__FILE__), '..', "spec_helper" )

describe User do
	before(:each) do
		@james = User.generate(:james)
		@joe = User.generate(:joe)
	end

	# this is testing whether DM knows its ass from its elbow
	# however, it is useful since I can likewise
	# check the validity of my factory objects (gen. by dm-sweatshop)
  it "should be valid" do
		@james.should be_valid
	end

  it "'joe smith' should be valid" do
		@joe.should be_valid
	end
	
	it "with three or more name parts should be valid" do
		@james.name = 'james joyner brown'
		@james.should be_valid
	end	
	
	it "with names of less then two parts should not be valid" do
		@james.name = 'james'
		@james.should_not be_valid
	end
	
	it "with names that have a number anywhere should not be valid" do
		@james.name = 'james'
		@james.should_not be_valid
	end
	
	it "with three parts the middle of which is an initial should be valid" do
		@james.name = 'james j. brown'
		@james.should be_valid
	end
	
	it "is not admin if it does not have an admin role" do
	  @james.should_not be_admin
  end
	
	it "is admin if has the admin role" do
	  @james.set_admin
	  @james.should be_admin
  end
  
  describe "when looking for a user by his name" do
    it "should not find any users that does not have the name string" do
      users_with_x = User.all_by_name_portion('x')
      users_with_x.should == []
    end
    
    it "should find the users with that substring anywhere in their name" do
      users_with_j = User.all_by_name_portion('J')
      users_with_j.should include(@james)
      users_with_j.should include(@joe)
    end
    
    it "should not be case sensitive" do
      users_with_j = User.all_by_name_portion('j')
      users_with_j.should include(@james)
      users_with_j.should include(@joe)      
    end
    
  end
    

end