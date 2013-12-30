class GamesController < ApplicationController
  before_action :require_signin
  before_action :authorize_user, only: [:show, :update, :destroy]
  before_action :prevent_overwriting, only: [:update]

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
    if params[:commit] == "Play as O"
      @game.computers_first_turn
    end

    if @game.save
      redirect_to game_path(@game)
    else
      redirect_to games_path, notice: "Something went wrong."
    end
  end

  def update
    gameplay = Gameplay.new(params)
    gameplay.play_turns

    if gameplay.check_status
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

  def prevent_overwriting
    @game = Game.find(params[:id])
    if @game.gamespot(params[:position].to_i).player.present?
      redirect_to game_path(@game), notice: "Hey! No cheating!"
    end
  end

end
