module Admin
  class Recommendations < Application
    
    before :ensure_admin
    def index
      @recommendations = Recommendation.all
      display @recommendations
    end
  end
end
