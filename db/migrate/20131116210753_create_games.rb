class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :status, null: false, default: 'in_progress'
      t.integer :number_of_turns, null: false, default: 0
      t.string :opponents_first_spot_type
    end
  end
end
