class Identity

  include DataMapper::Resource

  property :id, Serial, :index => true
  property :provider, String
  property :uid, String, :length => 255
  property :email, String, :length => 120


end
