class DrawnCardsController < ApplicationController
  before_action :auth_only!

  def create
    @game = Game.find(params[:game_id])
    if params[:dealer] == 'true' and @game.dealer_score.nil?
      @game.draw_card(nil)
      render 'dealer.js.erb'
    elsif @game.player_score.nil?
      @game.draw_card(current_user.id)
      render 'player.js.erb'
    else
      render :js => {}, status: 404
    end
  end

end