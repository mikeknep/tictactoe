class AddGametypeToGames < ActiveRecord::Migration
  def change
    add_column :games, :gametype, :string
  end
end
