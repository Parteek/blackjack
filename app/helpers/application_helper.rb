module ApplicationHelper
  def current_user
    if session[:email].present?
      User.where(email: session[:email]).first
    else
      nil
    end
  end
end
