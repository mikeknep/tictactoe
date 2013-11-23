class GamesController < ApplicationController

  before_action :set_game, only: [:show, :update, :destroy]

  def index
    @games = Game.all
  end

  def show
  end

  def create
    @game = Game.create
    redirect_to game_path(@game), notice: "Dang, that computer is fast! Looks like it's your turn."
  end

  def update
    # Play the human's move
    position = params[:position].to_i
    @game.human_turn(position)
    @game.human_turns += 1

    # Set the gametype on the first turn
    if @game.human_turns == 1
      case position
      when 3, 7, 9
        @game.gametype = 'corner'
      when 2, 4, 6, 8
        @game.gametype = 'peninsula'
      when 5
        @game.gametype = 'middle'
      end
    end

    # Play the computer's move
    @game.computer_turn(@game.human_turns + 1)

    # Check if the game is over
    @game.check_status

    if @game.save
      redirect_to game_path(@game), notice: @game.status == 'over' ? 'Game over!' : nil
    else
      redirect_to game_path(@game), notice: 'Something went wrong with your turn'
    end
  end

  def destroy
    @game.destroy
    redirect_to games_path
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

end
