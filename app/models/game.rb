class Game < ActiveRecord::Base
  require 'set'

  belongs_to :user
  has_many :spots, dependent: :destroy

  validates :status, presence: true

  def build_game_board
    1.upto(9) { |position| spots.build(position: position) }
  end

  def gamespot(position)
    spots.where(position: position).first
  end

  def computers_first_turn
    spot = gamespot(1)
    spot.player = 1
    spot.save
  end

end
