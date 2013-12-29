class ChangePlayerStore < ActiveRecord::Migration
  def change
    change_column :spots, :player, :integer
  end
end
