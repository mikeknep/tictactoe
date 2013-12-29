class Spot < ActiveRecord::Base
  belongs_to :game

  validates :position, presence: true
  validates :position, numericality: true
  validates :position, numericality: { greater_than_or_equal_to: 1 }
  validates :position, numericality: { less_than_or_equal_to: 9 }
  validates :position, uniqueness: { scope: :game_id }
  validates :player, inclusion: { in: [1,2] }, allow_blank: true
end
