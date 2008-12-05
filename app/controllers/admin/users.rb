module Admin
  class Users < Application
    before :ensure_admin
    
    def index
      @users = User.all
      display @users
    end
  
  end
end
