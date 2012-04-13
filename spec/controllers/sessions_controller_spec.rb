require 'spec_helper'

describe SessionsController do

  before do
    request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:twitter]

    OmniAuth.config.mock_auth[:twitter] = {
      'provider' => 'twitter', 'uid' => '123456',
      'info' => {
        'name' => 'John Doe'
      }
    }
  end
  describe "existing user" do
    context "not logged in" do
      it "searches identity and retrieves user info"
      it "logs user in"
    end

    context "logged in" do
      it "responds with existing identity if applicable"
      it "assigns new identity to user if none is found"
    end
  end

  describe "new user", :type => :request do
    it "authenticates with a service provider and logs in user" do
      # visit('/auth/twitter/')
      # puts response.inspect
      User.count.should == 0

      login_with_twitter
      fill_in 'email', :with => 'john@example.com'
      click_on 'Create account'
    end
  end
end
