require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/" do
  
  before(:all) do
    User.all.destroy!
    @james = User.gen(:james)
    @response = request("/")
  end
  
  it "should go to the landing page of the site" do
    @response.should contain("Welcome to")
  end
  
  it "should have 'Home' in the html title of the page" do
    pending
    @response.should have_selector("title[value='Home']")
  end
  
  describe "when a user is not logged in" do
    it "should see a login link" do
      @response.should have_selector("a[href='#{url(:login)}']")
    end
    it "should see a register link" do
      @response.should have_selector("a[href='#{url(:new_user)}']")
    end    
  end
  
  describe "when a user is logged in" do
    before(:each) do
      login(@james)
      @response = request("/")       
    end
    
    it "should see a link to see his profile" do
      @response.should have_selector("a[href='#{url(:user, :id => @james.id)}']")
    end    
    it "should see a link to edit his profile" do
      @response.should have_selector("a[href='#{url(:edit_user, :id => @james.id)}']")
    end
    it "should see a link to search users" do
      @response.should have_selector("a[href='#{url(:user_search)}']")
    end
    
  end
  
end