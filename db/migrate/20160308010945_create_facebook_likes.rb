class CreateFacebookLikes < ActiveRecord::Migration
  def change
    create_table :facebook_likes do |t|
      t.bigint :page_id
      t.integer :page_fan_adds
      t.integer :page_fan_removes
      t.integer :page_fans
      t.date :date

      t.timestamps null: false
    end
  end
end
