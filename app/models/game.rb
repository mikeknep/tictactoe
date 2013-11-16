class Game < ActiveRecord::Base
  has_many :spots, dependent: :destroy

  validates :status, presence: true

  after_create :build_game_board


  private

  def build_game_board
    9.times do |i|
      Spot.create(game: self, position: i+1)
    end
  end

end
