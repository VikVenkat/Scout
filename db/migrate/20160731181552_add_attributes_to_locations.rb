class AddAttributesToLocations < ActiveRecord::Migration
  def up
      add_column :locations, :city, :string
      add_column :locations, :state, :string
      add_column :locations, :zipcode, :string
      add_column :locations, :beds, :float
      add_column :locations, :baths, :float
      add_column :locations, :sqft, :float
      add_column :locations, :list_price, :float
      add_column :locations, :closing_price, :float
      add_column :locations, :rent_price, :float
      add_column :locations, :target_price, :float
      add_column :locations, :maintenance, :float
      add_column :locations, :taxes_annual, :float
      add_column :locations, :listing_type, :string #{live, sold, rental}
      add_column :locations, :zillow_page_link, :string
      add_column :locations, :zillow_id, :string
      add_column :locations, :commuter_hub, :boolean
      add_column :locations, :price_per_sqft, :float
      add_column :locations, :rent_per_sqft, :float
      add_column :locations, :taxpercent, :float
  end

  def down
    remove_column :locations, :city, :string
    remove_column :locations, :state, :string
    remove_column :locations, :zipcode, :string
    remove_column :locations, :beds, :float
    remove_column :locations, :baths, :float
    remove_column :locations, :sqft, :float
    remove_column :locations, :list_price, :float
    remove_column :locations, :closing_price, :float
    remove_column :locations, :rent_price, :float
    remove_column :locations, :target_price, :float
    remove_column :locations, :maintenance, :float
    remove_column :locations, :taxes_annual, :float
    remove_column :locations, :listing_type, :string #{live, sold, rental}
    remove_column :locations, :zillow_page_link, :string
    remove_column :locations, :zillow_id, :string
    remove_column :locations, :commuter_hub, :boolean
    remove_column :locations, :price_per_sqft, :float
    remove_column :locations, :rent_per_sqft, :float
    remove_column :locations, :taxpercent, :float
  end
end
