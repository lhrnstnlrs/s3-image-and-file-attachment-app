class CreatePictures < ActiveRecord::Migration[5.0]
  def change
    create_table :pictures do |t|
      t.references :imageable, polymorphic: true
      t.string :direct_upload_url, null: false

      t.boolean :processed, default: false, null: false

      t.timestamps null: false
    end
  end
end
