module Admin
  class Recommendations < Application
    
    before :ensure_admin
    def index
      "admin_recommendations_index"
    end
  end
end
