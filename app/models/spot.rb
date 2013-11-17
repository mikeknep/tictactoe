class Spot < ActiveRecord::Base
  belongs_to :game

  validates :game_id, presence: true
  validates :position, presence: true
  validates :position, numericality: true
  validates :position, numericality: { greater_than_or_equal_to: 1 }
  validates :position, numericality: { less_than_or_equal_to: 9 }
  validates :position, uniqueness: { scope: :game_id }
  validates :player, format: { with: /X|O/ }, allow_blank: true
end
