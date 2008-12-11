class Reason
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String, :nullable => false
  
  has 0..n, :recommendations, :through => Resource

end
