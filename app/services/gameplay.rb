class Gameplay
  require 'set'

  def initialize(params)
    @game = Game.find(params[:id])
    @position = params[:position].to_i
  end

  def play_turns
    human_turn
    computer_turn(@game.spots.where(player: 'X').count + 1)
  end

  def check_status
    x_spots = @game.spots.where(player: 'X').map{ |s| s.position }.to_set
    all_victories = [[1,2,3], [4,5,6], [7,8,9], [1,4,7], [2,5,8], [3,6,9], [1,5,9], [3,5,7]].map{ |a| a.to_set }

    all_victories.each { |array| @game.status = 'over' if array.subset?(x_spots) }
    @game.status = 'over' if @game.spots.where(player: nil).empty?

    @game.save
  end


  private


  def set_gametype(position)
    case position
    when 3, 7, 9
      @game.gametype = 'corner'
    when 2, 4, 6, 8
      @game.gametype = 'peninsula'
    when 5
      @game.gametype = 'middle'
    end
    @game.save
  end

  def take_turn(preferred_spot, alt_spot)
    next_move = preferred_spot.player.nil? ? preferred_spot : alt_spot
    next_move.player = 'X'
    next_move.save
  end

  def human_turn
    if @game.spots.where(player: 'X').count == 1
      set_gametype(@position)
    end

    spot = @game.gamespot(@position)
    spot.player = 'O'
    spot.save
    @game.human_turns += 1
  end

  def computer_turn(number)
    case number
    when 2
      computers_second_turn
    when 3
      computers_third_turn
    when 4
      computers_fourth_turn
    when 5
      computers_fifth_turn
    end
  end

  def computers_first_turn
    spot = @game.gamespot(1)
    spot.player = 'X'
    spot.save
  end


  def computers_second_turn
    if @game.gametype == 'middle'
      spot = @game.gamespot(2)
      spot.player = 'X'
      spot.save

    elsif @game.gametype == 'corner'
      preferred_spot = @game.gamespot(3)
      alt_spot = @game.gamespot(7)

      take_turn(preferred_spot, alt_spot)

    elsif @game.gametype == 'peninsula'
      spot = @game.gamespot(5)
      spot.player = 'X'
      spot.save
    end
  end


  def computers_third_turn
    if @game.gametype == 'middle'
      preferred_spot = @game.gamespot(3)
      alt_spot = @game.gamespot(7)

    elsif @game.gametype == 'corner'
      if @game.gamespot(3).player == 'X'
        preferred_spot = @game.gamespot(2)
        alt_spot = spots.where(position: [7, 9]).where(player: nil).first
      elsif @game.gamespot(7).player == 'X'
        preferred_spot = @game.gamespot(4)
        alt_spot = spots.where(position: [3, 9]).where(player: nil).first
      end

    elsif @game.gametype == 'peninsula'
      preferred_spot = @game.gamespot(9)
      if @game.gamespot(2).player == 'O' || @game.gamespot(8).player == 'O'
        alt_spot = @game.gamespot(7)
      elsif @game.gamespot(4).player == 'O' || @game.gamespot(6).player == 'O'
        alt_spot = @game.gamespot(3)
      end
    end

    take_turn(preferred_spot, alt_spot)
  end

  def computers_fourth_turn
    if @game.gametype == 'middle'
      preferred_spot = @game.gamespot(4)
      alt_spot = @game.gamespot(6)

    elsif @game.gametype == 'corner'
      preferred_spot = @game.gamespot(5)
      if @game.gamespot(3).player == 'X' && @game.gamespot(7).player == 'X'
        alt_spot = @game.gamespot(4)
      elsif @game.gamespot(3).player == 'X' && @game.gamespot(9).player == 'X'
        alt_spot = @game.gamespot(6)
      elsif @game.gamespot(7).player == 'X' && @game.gamespot(9).player == 'X'
        alt_spot = @game.gamespot(8)
      end

    elsif @game.gametype == 'peninsula'
      if @game.gamespot(3).player == 'X'
        preferred_spot = @game.gamespot(2)
        alt_spot = @game.gamespot(7)
      elsif @game.gamespot(7).player == 'X'
        preferred_spot = @game.gamespot(3)
        alt_spot = @game.gamespot(4)
      end
    end

    take_turn(preferred_spot, alt_spot)
  end


  def computers_fifth_turn
    next_move = @game.spots.where(player: nil).first
    next_move.player = 'X'
    next_move.save
  end


end
