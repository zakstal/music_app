class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  #put me back on
  def current_user
  	return nil unless session[:toekn]
  	session[:token] = User.find_by_session_token(session[:token])
  end

  def signed_in?
  	!!current_user
  end

  def sign_in(user)
  	@current_user = user
  	session[:token] = @current_user.reset_session_token!
  end

  def sign_out
  	current_user.try(:reset_session_token!)
  	session[:token] = nil
  end

  def require_signed_in!
  	redirect_to new_session_url unless signed_in?
  end

  def require_signed_out!
  	redirect_to user_url(current_user) if signed_in?
  	
  end

end
