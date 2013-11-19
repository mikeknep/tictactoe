class GamesController < ApplicationController

  def index
    @games = Game.all
  end

  def show
    @game = Game.find(params[:id])
  end

  def create
    @game = Game.create
    redirect_to game_path(@game), notice: "Dang, that computer is fast! Looks like it's your turn."
  end

  def human_turn_1
    @game = Game.find(params[:game_id])

    position = params[:position].to_i
    @game.human_turn(position)
    @game.human_turns += 1

    case position
    when 3, 7, 9
      @game.gametype = 'corner'
    when 2, 4, 6, 8
      @game.gametype = 'peninsula'
    when 5
      @game.gametype = 'middle'
    end

    @game.computers_second_turn

    if @game.save
      redirect_to game_path(@game)
    else
      redirect_to game_path(@game), notice: 'Something went wrong with your turn'
    end
  end

  def human_turn_2
    @game = Game.find(params[:game_id])

    position = params[:position].to_i
    @game.human_turn(position)
    @game.human_turns += 1

    @game.computers_third_turn
    @game.check_status

    if @game.save
      redirect_to game_path(@game), notice: @game.status == 'over' ? 'Game over!' : nil
    else
      redirect_to game_path(@game), notice: 'Something went wrong with your turn'
    end
  end

  def human_turn_3
    @game = Game.find(params[:game_id])

    position = params[:position].to_i
    @game.human_turn(position)
    @game.human_turns += 1

    @game.computers_fourth_turn
    @game.check_status

    if @game.save
      redirect_to game_path(@game), notice: @game.status == 'over' ? 'Game over!' : nil
    else
      redirect_to game_path(@game), notice: 'Something went wrong with your turn'
    end
  end

  def human_turn_4
    @game = Game.find(params[:game_id])

    position = params[:position].to_i
    @game.human_turn(position)
    @game.human_turns += 1

    @game.computers_fifth_turn
    @game.check_status

    if @game.save
      redirect_to game_path(@game), notice: @game.status == 'over' ? 'Game over!' : nil
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
