class Recommendations < Application
  # provides :xml, :yaml, :js
  controlling :recommendations do |r|
    r.belongs_to :user
  end

end # Recommendations
