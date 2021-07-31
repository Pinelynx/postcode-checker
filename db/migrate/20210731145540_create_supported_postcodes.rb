class CreateSupportedPostcodes < ActiveRecord::Migration[6.1]
  def change
    create_table :supported_postcodes do |t|
      t.references :supported_lsoa
      t.string :postcode, index: true

      t.timestamps
    end
  end
end
