class Identity

  include DataMapper::Resource

  property :id, Serial, :index => true
  property :provider, String, :index => [:service_provider]
  property :uid, String, :length => 255, :index => [:service_provider]
  # property :email, String, :length => 120

  belongs_to :user

  def self.find_with_omniauth(auth)
    self.first(:provider => auth['provider'], :uid => auth['uid'])
  end

  # def self.create_with_omniauth(auth)
  #   self.create(:uid => auth['uid'], :provider => auth['provider'])
  # end
end
