class GamesController < ApplicationController

  def index
    @games = Game.all
  end

  def show
    @game = Game.find(params[:id])
  end

  def create
    @game = Game.create
    redirect_to game_path(@game)
  end

  def first_human_turn
    @game = Game.find(params[:game_id])

    position = params[:position].to_i
    spot = Spot.where(game: @game).where(position: position).first
    spot.player = 'O'
    spot.save

    case position
    when 3, 7, 9
      @game.gametype = 'corner'
    when 2, 4, 6, 8
      @game.gametype = 'peninsula'
    when 5
      @game.gametype = 'middle'
    end

    @game.number_of_turns += 1

    if @game.save
      redirect_to game_path(@game)
    else
      redirect_to game_path(@game), notice: 'Something went wrong with your turn'
    end
  end

  def destroy
    @game = Game.find(params[:id])
    @game.destroy
    redirect_to games_path
  end

end
