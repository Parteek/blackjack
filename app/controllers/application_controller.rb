class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound, with: -> { error 404 }
  rescue_from Exceptions::UnauthorizedAccess, with: -> { error 401 }

  def current_user
    if session[:email].present?
      User.where(email: session[:email]).first
    else
      nil
    end
  end

  def auth_only!
    if current_user.blank?
      raise Exceptions::UnauthorizedAccess, 'Unauthorized'
    end
  end

  def auth_redirect!
    if current_user.present?
      redirect_to new_game_path
    end
  end

  def error status
    render "#{status}"
  end
end
