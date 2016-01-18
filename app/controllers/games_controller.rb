class GamesController < ApplicationController
  before_action :auth_only!
  before_action :set_game, only: [:show]

  def new
    @game = current_user.games.build()
  end

  def show
  end

  def create
    @game = current_user.games.build(game_params)
    if @game.save
      redirect_to @game
    else
      render :new
    end
  end


  private

  def game_params
    params.require(:game).permit(:bet_amount)
  end

  def set_game
    @game = Game.find(params[:id])
  end
end