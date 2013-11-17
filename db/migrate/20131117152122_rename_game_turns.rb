class RenameGameTurns < ActiveRecord::Migration
  def change
    rename_column :games, :number_of_turns, :human_turns
  end
end
