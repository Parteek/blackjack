class UsersController < ApplicationController

  def create
    @user = User.find_or_create_by(email: user_params[:email])
    session[:email] = @user.email
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end

end