class UsersController < ApplicationController
  before_action :auth_redirect!, only: [:create]

  def create
    @user = User.find_or_create_by(email: user_params[:email])
    session[:email] = @user.email
    redirect_to new_game_path
  end

  def stats

  end

  private

  def user_params
    params.require(:user).permit(:email)
  end
end