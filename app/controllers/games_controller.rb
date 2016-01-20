class GamesController < ApplicationController
  before_action :auth_only!
  before_action :set_game, only: [:player_stop, :dealer_stop]

  def new
    @game = current_user.games.build()
  end

  def show
    @game = Game.includes(:drawn_cards).where(id: params[:id]).first
    game_owner_only!
  end

  def create
    @game = current_user.games.build(game_params)
    if @game.save
      redirect_to @game
    else
      render :new
    end
  end

  def player_stop
    game_owner_only!
    @game.stop(current_user.id)
    redirect_to @game
  end

  def dealer_stop
    game_owner_only!
    if @game.dealer_stop?
      @game.stop(nil)
      redirect_to @game
    else
      redirect_to @game, alert: 'Dealer cannot stop before 17'
    end

  end

  private

  def game_params
    params.require(:game).permit(:bet_amount)
  end

  def set_game
    @game = Game.find(params[:id])
  end

  def game_owner_only!
    if @game.user_id != current_user.id
      raise Exceptions::UnauthorizedAccess, 'Unauthorized'
    end
  end
end