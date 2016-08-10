class AddFeaturesToLocation < ActiveRecord::Migration
  def up
    add_column :locations, :closing_price_type, :boolean #So we can have estimates, actuals, etc
    add_column :locations, :parking_units, :float
    add_column :locations, :agent, :string
    add_column :locations, :last_sold_date, :string
    add_column :locations, :last_sold_price, :string
    add_column :locations, :sqft_type, :string
    add_column :locations, :maintenance_type, :boolean
    add_column :locations, :taxes_annual_type, :boolean
    add_column :locations, :rent_price_type, :boolean
  end
  def down
    remove_column :locations, :close_type, :boolean
    remove_column :locations, :parking_units, :float
    remove_column :locations, :agent, :string
    remove_column :locations, :last_sold_date, :string
    remove_column :locations, :last_sold_price, :string
    remove_column :locations, :sqft_type, :boolean
    remove_column :locations, :maintenance_type, :boolean
    remove_column :locations, :taxes_annual_type, :boolean
    remove_column :locations, :rent_price_type, :boolean
  end
end
