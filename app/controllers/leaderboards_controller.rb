class LeaderboardsController < ApplicationController
  before_action :auth_only!

  #user with most wins default
  def index
    @users = User.joins(:games).where(games: {status: 'won'}).group('users.id').order('count(games.*) DESC').select('users.*, count(games.*) as won_games').page(params[:page])
  end

end