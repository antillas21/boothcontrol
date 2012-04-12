class User

  include DataMapper::Resource

  property :id, Serial, :index => true
  property :name, String, :length => 100, :index => true
  property :email, String, :index => true
  property :image, String, :length => 255

  has n, :identities

end
