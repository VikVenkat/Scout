class AddCardinalstoTarget < ActiveRecord::Migration
  def up
    add_column :targets, :north, :float
    add_column :targets, :south, :float
    add_column :targets, :east, :float
    add_column :targets, :west, :float
  end

  def down
    remove_column :targets, :north, :float
    remove_column :targets, :south, :float
    remove_column :targets, :east, :float
    remove_column :targets, :west, :float
  end
end
