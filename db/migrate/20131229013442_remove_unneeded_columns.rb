class RemoveUnneededColumns < ActiveRecord::Migration
  def change
    remove_column :games, :gametype
    remove_column :games, :human_turns
  end
end
