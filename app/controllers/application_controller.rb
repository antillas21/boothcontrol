require 'dm-rails/middleware/identity_map'

class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def current_user  
    @current_user ||= User.get(session[:user_id]) if session[:user_id]  
  end

  def user_signed_in?
    return 1 if current_user
  end
end
