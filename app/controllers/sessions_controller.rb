class SessionsController < ApplicationController
  def create
    auth = request.env['omniauth.auth']
    credentials = {
      :uid => auth['uid'], :provider => auth['provider'],
      :name => auth['info']['name'], :email => auth['info']['email'].to_s,
      :image => auth['info']['image'].to_s
    }

    if auth['uid'] != '' and auth['provider'] != ''

      # find an identity
      identity = Identity.find_with_omniauth(auth)

      # if user is currently signed in, he/she might want to add another identity
      if user_signed_in?
        if identity
          # if signed in and identity not nil
          redirect_to root_url, :notice => "Your account at #{auth['provider'].capitalize} 
          is already connected with this site"
        else
          # current_user.identities.create_with_omniauth(auth)
          current_user.identities.create!(
            :uid => credentials[:uid], :provider => credentials[:provider]
          )
          redirect_to root_url, :notice => "Your account at #{auth['provider'].capitalize} 
          has been added for sign in at this site."
        end
      else
        if identity
          # no user signed in, but identity exists, so we sign him/her in
          session[:user_id] = identity.user.id
          session[:identity_id] = identity.id

          redirect_to root_url, :notice => "Signed in successfully via #{identity.provider.capitalize}"
        else
          # this is a new user, so route him/her to registration page
          session[:auth_hash] = credentials
          render signup_sessions_path
        end
      end
    else
      redirect_to root_url, :error => 'Error while authenticating. The service did not return valid data.' 
    end
  end

  def new_account
    if params[:commit] == "Cancel"
      cancel_signup
    else
      @new_user = User.new(
        :name => params[:name],
        :email => params[:email],
        :image => params[:image]
      )
      set_email
      if @new_user.save
        @new_user.identities.create!(
          :uid => session[:auth_hash][:uid], :provider => session[:auth_hash][:provider]
        )

        session[:user_id] = @new_user.id
        session[:identity_id] = @new_user.identities.first.id

        redirect_to root_url, :notice => "Your account has been created and you have
        been signed in!"
      else
        flash[:error] = "This is embarrasing. There was an error while creating your account 
        from which we were unable to recover."
      end
    end
  end

  def destroy
    @identity = current_user.services.get(params[:id])

    if session[:identity_id] == @identity.id
      flash[:error] = 'You are currently signed in with this account!'
    else
      @identity.destroy
    end

    redirect_to root_url
  end

  def signout 
    if current_user
      session[:user_id] = nil
      session[:identity_id] = nil
      session.delete :user_id
      session.delete :identity_id
      flash[:notice] = 'You have been signed out!'
    end  
    redirect_to root_url
  end

  def failure
    redirect_to root_url, :error => 'There was an error at the remote authentication identity. You have not been signed in.'
  end
  
  private
  
  def cancel_signup
    session[:auth_hash] = nil
    session.delete :auth_hash
    redirect_to root_url, :notice => 'You decided not to create an account with us. Come back soon.'
  end
  
  def set_email
    if session[:auth_hash][:email].blank?
      if params[:email].blank?
        flash[:error] = 'You should enter an email address. Please try again.'
        # redirect_to signup_identitys_path
      else
        @new_user.email = params[:email]
      end
    else
      @new_user.email = session[:auth_hash][:email]
    end
  end

end
