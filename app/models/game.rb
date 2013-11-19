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
