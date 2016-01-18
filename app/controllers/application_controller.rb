class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    if session[:email].present?
      User.where(email: session[:email]).first
    else
      nil
    end
  end
end
