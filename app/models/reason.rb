class Reason
  include DataMapper::Resource
  
  property :id, Serial
  
  has 0..n, :recommendations, :through => Resource

end
