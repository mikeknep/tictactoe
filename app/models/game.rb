class Game < ActiveRecord::Base
  require 'set'

  belongs_to :user
  has_many :spots, dependent: :destroy

  validates :status, presence: true


  def build_game_board
    1.upto(9) { |position| spots.build(position: position) }
  end


  def set_gametype(position)
    case position
    when 3, 7, 9
      self.gametype = 'corner'
    when 2, 4, 6, 8
      self.gametype = 'peninsula'
    when 5
      self.gametype = 'middle'
    end
  end


  def gamespot(position)
    spots.where(position: position).first
  end


  def human_turn(position)
    spot = gamespot(position)
    spot.player = 'O'
    spot.save
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


  def take_turn(preferred_spot, alt_spot)
    next_move = preferred_spot.player.nil? ? preferred_spot : alt_spot
    next_move.player = 'X'
    next_move.save
  end


  def computers_first_turn
    spot = gamespot(1)
    spot.player = 'X'
    spot.save
  end


  def computers_second_turn
    if gametype == 'middle'
      spot = gamespot(2)
      spot.player = 'X'
      spot.save

    elsif gametype == 'corner'
      preferred_spot = gamespot(3)
      alt_spot = gamespot(7)

      take_turn(preferred_spot, alt_spot)

    elsif gametype == 'peninsula'
      spot = gamespot(5)
      spot.player = 'X'
      spot.save
    end
  end


  def computers_third_turn
    if gametype == 'middle'
      preferred_spot = gamespot(3)
      alt_spot = gamespot(7)

    elsif gametype == 'corner'
      if gamespot(3).player == 'X'
        preferred_spot = gamespot(2)
        alt_spot = spots.where(position: [7, 9]).where(player: nil).first
      elsif gamespot(7).player == 'X'
        preferred_spot = gamespot(4)
        alt_spot = spots.where(position: [3, 9]).where(player: nil).first
      end

    elsif gametype == 'peninsula'
      preferred_spot = gamespot(9)
      if gamespot(2).player == 'O' || gamespot(8).player == 'O'
        alt_spot = gamespot(7)
      elsif gamespot(4).player == 'O' || gamespot(6).player == 'O'
        alt_spot = gamespot(3)
      end
    end

    take_turn(preferred_spot, alt_spot)
  end

  def computers_fourth_turn
    if gametype == 'middle'
      preferred_spot = gamespot(4)
      alt_spot = gamespot(6)

    elsif gametype == 'corner'
      preferred_spot = gamespot(5)
      if gamespot(3).player == 'X' && gamespot(7).player == 'X'
        alt_spot = gamespot(4)
      elsif gamespot(3).player == 'X' && gamespot(9).player == 'X'
        alt_spot = gamespot(6)
      elsif gamespot(7).player == 'X' && gamespot(9).player == 'X'
        alt_spot = gamespot(8)
      end

    elsif gametype == 'peninsula'
      if gamespot(3).player == 'X'
        preferred_spot = gamespot(2)
        alt_spot = gamespot(7)
      elsif gamespot(7).player == 'X'
        preferred_spot = gamespot(3)
        alt_spot = gamespot(4)
      end
    end

    take_turn(preferred_spot, alt_spot)
  end


  def computers_fifth_turn
    next_move = spots.where(player: nil).first
    next_move.player = 'X'
    next_move.save
  end


  def check_status
    x_spots = spots.where(player: 'X').map{ |s| s.position }.to_set
    all_victories = [[1,2,3], [4,5,6], [7,8,9], [1,4,7], [2,5,8], [3,6,9], [1,5,9], [3,5,7]].map{ |a| a.to_set }

    all_victories.each do |array|
      if array.subset?(x_spots)
        self.status = 'over'
      end
    end

    if spots.where(player: nil).empty?
      self.status = 'over'
    end
  end

end
