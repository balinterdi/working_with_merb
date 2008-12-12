class Recommendation
  include DataMapper::Resource
  
	property	:user_id, Integer, :key => true
	property	:recommendee_id, Integer, :key => true
	
	belongs_to :user, :child_key => [:user_id]
	belongs_to :recommendee, :child_key => [:recommendee_id], :class_name => "User"

  # has 1..n, :reasons, :through => :recommendation_reasons
  has 1..n, :reasons, :through => Resource
  
  validates_with_block :recommendee_id do
    if @recommendee_id == @user_id
      [false, "A user can not recommend himself"]
    else
      true
    end
  end
  
  def recommendee_name
    recommendee ? recommendee.name : nil
  end
  
  def recommendee_name=(name)
    self.recommendee = User.first(:name => name)
  end
  
  def reason_attributes=(reason_attrs)
    reason_attrs.each do |reason_id|
      self.reasons << Reason.get(reason_id)
    end
  end
  
end
