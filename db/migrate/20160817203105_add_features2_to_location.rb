class AddFeatures2ToLocation < ActiveRecord::Migration
  def up
    add_column :locations, :maint_percent, :float
    add_column :locations, :caprate, :float
  end
  def down
    remove_column :locations, :maint_percent, :float
    remove_column :locations, :caprate, :float
  end
end
