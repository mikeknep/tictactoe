class GamesController < ApplicationController
  before_action :require_signin
  before_action :authorize_user, except: [:index, :create]

  def index
    @games = Game.where(user: current_user).includes(:user)
  end

  def show
    @game = Game.find(params[:id])
  end

  def create
    @game = Game.new(user: current_user)
    @game.build_game_board
    @game.save
    @game.computers_first_turn

    if @game.save
      redirect_to game_path(@game), notice: "Dang, that computer is fast! Looks like it's your turn."
    else
      redirect_to games_path, notice: "Something went wrong."
    end
  end

  def update
    @game = Game.find(params[:id])

    # Play the human's move
    position = params[:position].to_i
    @game.human_turn(position)
    @game.human_turns += 1

    # Set the gametype on the first turn
    @game.set_gametype(position) if @game.human_turns == 1

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
    @game = Game.find(params[:id])
    @game.destroy
    redirect_to games_path
  end

  private

  def require_signin
    if current_user.nil?
      redirect_to root_path, notice: "You must be signed in to view that page."
    end
  end

  def authorize_user
    @game = Game.find(params[:id])
    unless @game.user == current_user
      redirect_to games_path, notice: "You are not allowed to view other players' games."
    end
  end

end
