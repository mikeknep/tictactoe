class RemoveDupeColumnFromGames < ActiveRecord::Migration
  def change
    remove_column :games, :opponents_first_spot_type
  end
end
