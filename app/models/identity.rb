class Identity

  include DataMapper::Resource

  property :id, Serial, :index => true
  property :provider, String, :required => true, :index => [:service_provider]
  property :uid, String, :length => 255, :required => true, :index => [:service_provider]

  validates_presence_of :provider, :uid
  validates_uniqueness_of :uid

  belongs_to :user

  def self.find_with_omniauth(auth)
    self.first(:provider => auth['provider'], :uid => auth['uid'])
  end

  # def self.create_with_omniauth(auth)
  #   self.create(:uid => auth['uid'], :provider => auth['provider'])
  # end
end
