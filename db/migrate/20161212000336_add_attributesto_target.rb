class AddAttributestoTarget < ActiveRecord::Migration
  def up
    add_column :targets, :address, :string
    add_column :targets, :latitude, :float
    add_column :targets, :longitude, :float
  end

  def down
    remove_column :targets, :address, :string
    remove_column :targets, :latitude, :float
    remove_column :targets, :longitude, :float
  end
end
