class Recommendation
  include DataMapper::Resource
  
	property	:user_id, Integer, :key => true
	property	:recommendee_id, Integer, :key => true
	# property 	:id, Serial
	# property	:user_id, Integer, :nullable => false
	# property	:recommendee_id, Integer, :nullable => false	
	
	belongs_to :user, :child_key => [:user_id]
	belongs_to :recommendee, :child_key => [:recommendee_id], :class_name => "User"
  
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
  
end
