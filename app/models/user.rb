class User

  include DataMapper::Resource

  property :id, Serial, :index => true
  property :name, String, :length => 100, :required => true, :index => true
  property :email, String, :index => true, :required => true, :unique => true
  property :image, String, :length => 255

  has n, :identities

  validates_presence_of :name, :email
  validates_format_of :email, :as => :email_address
  validates_uniqueness_of :email

end
