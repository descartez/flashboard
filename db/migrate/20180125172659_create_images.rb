class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.text :image
      t.boolean :visible

      t.timestamps
    end
  end
end
