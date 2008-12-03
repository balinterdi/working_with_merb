require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe "/" do
  before(:each) do
    @response = request("/")
  end
  
  it "goes to the landing page of the site" do
    @response.should contain("Welcome to Working with Merb!")
  end
end