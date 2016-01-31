class GamesController < ApplicationController
  before_action :auth_only!
  before_action :set_game, only: [:player_stop, :dealer_stop]

  # it creates an instance of game with signed in user
  # renders the form in which the user is asked for bet amount
  def new
    @game = current_user.games.build()
  end

  # it shows the game with given id, only game owner can see.
  def show
    @game = Game.includes(:drawn_cards).where(id: params[:id]).first
    game_owner_only!
  end

  # it creates the game with bet_amount as params and user_id from current_user
  def create
    @game = current_user.games.build(game_params)
    if @game.save
      redirect_to @game
    else
      render :new
    end
  end

  # This action stands the user at particular score
  # saves the max possible score in the game
  def player_stop
    game_owner_only!
    @game.stop(current_user.id)
    redirect_to @game
  end

  # this action check for whether dealer can stop
  # if dealer can stop it stops the dealer
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