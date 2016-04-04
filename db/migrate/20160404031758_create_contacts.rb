class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.references :company, index: true, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :mobile
      t.string :email

      t.timestamps null: false
    end
  end
end
