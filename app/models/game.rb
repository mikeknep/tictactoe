class Game < ActiveRecord::Base
  has_many :spots, dependent: :destroy

  validates :status, presence: true

  after_create :build_game_board
  after_create :computers_first_turn


  def computers_second_turn
    if gametype == 'middle'
      spot = Spot.where(game: self).where(position: 9).first
      spot.player = 'X'
      spot.save

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
