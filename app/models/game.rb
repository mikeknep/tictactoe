class Game < ActiveRecord::Base
  has_many :spots, dependent: :destroy

  validates :status, presence: true

  after_create :build_game_board
  after_create :computers_first_turn

  def human_turn(position)
    spot = Spot.where(game_id: self.id).where(position: position).first
    spot.player = 'O'
    spot.save
  end


  def computers_second_turn
    if gametype == 'middle'
      spot = Spot.where(game: self).where(position: 2).first
      spot.player = 'X'
      spot.save

    # elsif gametype == 'corner'
      #
    # elsif gametype == 'peninsula'
      #
    end
  end


  def computers_third_turn
    if gametype == 'middle'
      winning_spot = spots.where(position: 3).first
      alt_spot = spots.where(position: 7).first

      next_move = winning_spot.player.nil? ? winning_spot : alt_spot
      next_move.player = 'X'
      next_move.save

    # elsif gametype == 'corner'
      #
    # elsif gametype == 'peninsula'
      #
    end
  end

  def computers_fourth_turn
    if gametype == 'middle'
      winning_spot = spots.where(position: 4).first
      alt_spot = spots.where(position: 6).first

      next_move = winning_spot.player.nil? ? winning_spot : alt_spot
      next_move.player = 'X'
      next_move.save

    # elsif gametype == 'corner'
      #
    # elsif gametype == 'peninsula'
      #
    end
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
    elsif x_spots.include?(1) && x_spots.include?(4) && x_spots.include?(7)
      self.status = 'over'
    elsif x_spots.include?(1) && x_spots.include?(5) && x_spots.include?(9)
      self.status = 'over'
    end

    if spots.where(player: nil).empty?
      self.status = 'over'
    end
  end

  private

  def build_game_board
    9.times do |i|
      Spot.create(game: self, position: i+1)
    end
  end

  def computers_first_turn
    spot = Spot.where(game: self).where(position: 1).first
    spot.player = 'X'
    spot.save
  end

end
