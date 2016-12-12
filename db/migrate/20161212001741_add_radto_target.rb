class AddRadtoTarget < ActiveRecord::Migration
  def up
    add_column :targets, :radius, :float
  end

  def down
    remove_column :targets, :radius, :float
  end
end
