module Admin
  class Users < Application
    def index
      @users = User.all
      display @users
    end
  
  end
  
  class Recommendations < Application
    def index
      "admin_recommendations_index"
    end
  end
  
end
