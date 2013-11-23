class Game < ActiveRecord::Base
  has_many :spots, dependent: :destroy

  validates :status, presence: true

  after_create :build_game_board
  after_create :computers_first_turn


  def build_game_board
    9.times do |i|
      Spot.create(game: self, position: i+1)
    end
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


  def human_turn(position)
    spot = Spot.where(game_id: self.id).where(position: position).first
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


  def computers_first_turn
    spot = Spot.where(game: self).where(position: 1).first
    spot.player = 'X'
    spot.save
  end


  def computers_second_turn
    if gametype == 'middle'
      spot = Spot.where(game: self).where(position: 2).first
      spot.player = 'X'
      spot.save

    elsif gametype == 'corner'
      preferred_spot = spots.where(position: 9).first
      alt_spot = spots.where(position: 7).first

      next_move = preferred_spot.player.nil? ? preferred_spot : alt_spot
      next_move.player = 'X'
      next_move.save

    elsif gametype == 'peninsula'
      spot = Spot.where(game: self).where(position: 5).first
      spot.player = 'X'
      spot.save
    end
  end


  def computers_third_turn
    if gametype == 'middle'
      preferred_spot = spots.where(position: 3).first
      alt_spot = spots.where(position: 7).first

    elsif gametype == 'corner'
      if spots.where(position: 9).first.player == 'X'
        preferred_spot = spots.where(position: 5).first
        alt_spot = spots.where("position = ? OR position = ?", 3, 7).where(player: nil).first
      else
        preferred_spot = spots.where(position: 4).first
        alt_spot = spots.where(position: 3).where(player: nil).first
      end

    elsif gametype == 'peninsula'
      preferred_spot = spots.where(position: 9).first
      if spots.where(position: 2).first.player == 'O' || spots.where(position: 8).first.player == 'O'
        alt_spot = spots.where(position: 7).first
      elsif spots.where(position: 4).first.player == 'O' || spots.where(position: 6).first.player == 'O'
        alt_spot = spots.where(position: 3).first
      end
    end

    next_move = preferred_spot.player.nil? ? preferred_spot : alt_spot
    next_move.player = 'X'
    next_move.save
  end

  def computers_fourth_turn
    if gametype == 'middle'
      preferred_spot = spots.where(position: 4).first
      alt_spot = spots.where(position: 6).first

    elsif gametype == 'corner'
      if spots.where(position: 9).first.player == 'X'
        preferred_spot = spots.where(position: 4).first
        alt_spot = spots.where(position: 8).first
      else
        preferred_spot = spots.where(position: 2).first
        alt_spot = spots.where(position: 5).first
      end

    elsif gametype == 'peninsula'
      if spots.where(position: 3).first.player == 'X'
        preferred_spot = spots.where(position: 2).first
        alt_spot = spots.where(position: 7).first
      elsif spots.where(position: 7).first.player == 'X'
        preferred_spot = spots.where(position: 3).first
        alt_spot = spots.where(position: 4).first
      end
    end

    next_move = preferred_spot.player.nil? ? preferred_spot : alt_spot
    next_move.player = 'X'
    next_move.save
  end


  def computers_fifth_turn
    next_move = spots.where(player: nil).first
    next_move.player = 'X'
    next_move.save
  end


  def check_status
    # 1-2-3, 4-5-6, 7-8-9 horizontal
    # 1-4-7, 2-5-8, 3-6-9 vertical
    # 1-5-9, 3-5-7        diagonal
    x_spots = spots.where(player: 'X').map{ |s| s.position }.sort
    if x_spots.include?(1) && x_spots.include?(2) && x_spots.include?(3)
      self.status = 'over'
    elsif x_spots.include?(7) && x_spots.include?(8) && x_spots.include?(9)
      self.status = 'over'
    elsif x_spots.include?(1) && x_spots.include?(4) && x_spots.include?(7)
      self.status = 'over'
    elsif x_spots.include?(1) && x_spots.include?(5) && x_spots.include?(9)
      self.status = 'over'
    elsif x_spots.include?(3) && x_spots.include?(5) && x_spots.include?(7)
      self.status = 'over'
    end

    if spots.where(player: nil).empty?
      self.status = 'over'
    end
  end

end
