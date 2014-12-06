class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :website
      t.string :description
      t.attachment :logo
      t.string :address
      t.float :latitude
      t.float :longitude
      t.integer :founded_in
      t.boolean :approved
      t.string :submitter_email
      t.string :submitter_name
      t.references :category, index: true

      t.timestamps
    end
  end
end
