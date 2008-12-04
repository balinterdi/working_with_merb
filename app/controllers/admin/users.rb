module Admin
  class Users < Application
    def index
      @users = User.all
      display @users
    end
  
  end
end
