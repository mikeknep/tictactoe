class CreateSpots < ActiveRecord::Migration
  def change
    create_table :spots do |t|
      t.integer :position, null: false
      t.integer :game_id, null: false
      t.string :player
    end
  end
end
