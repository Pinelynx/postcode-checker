class CreateSupportedLsoas < ActiveRecord::Migration[6.1]
  def change
    create_table :supported_lsoas do |t|
      t.string :starts_with, index: { unique: true }

      t.timestamps
    end
  end
end
