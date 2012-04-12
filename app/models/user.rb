class User

  include DataMapper::Resource

  property :id, Serial, :index => true
  property :name, String, :length => 100, :index => true


end
