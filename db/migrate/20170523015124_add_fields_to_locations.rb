class AddFieldsToLocations < ActiveRecord::Migration
  def up
    add_column :locations, :beds_type, :boolean
    add_column :locations, :baths_type, :boolean
    add_column :locations, :real_price, :float
    add_column :locations, :real_price_type, :boolean
  end
  def down
    remove_column :locations, :beds_type, :boolean
    remove_column :locations, :baths_type, :boolean
    remove_column :locations, :real_price, :float
    remove_column :locations, :real_price_type, :boolean
  end
end
