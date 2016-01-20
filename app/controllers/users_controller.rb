class UsersController < ApplicationController
  before_action :auth_redirect!, only: [:create]

  def create
    @user = User.find_or_create_by(email: user_params[:email])
    if(@user.errors.blank?)
      session[:email] = @user.email
      redirect_to find_game_path
    else
      redirect_to root_path, alert: 'Enter correct email'
    end
  end

  def stats
    @user = User.find(params[:id])
    @games = @user.games.where.not(status: 'pending').order('updated_at DESC')
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end

  def find_game_path
    games = @user.games.order('created_at DESC')
    if games.first and games.first.pending?
      game_path(games.first)
    else
      new_game_path
    end
  end
end