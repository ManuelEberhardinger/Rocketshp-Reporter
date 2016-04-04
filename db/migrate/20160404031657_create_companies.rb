class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :description
      t.string :lead_source
      t.string :job_types
      t.string :website
      t.integer :monthly_total
      t.integer :predicting_value
      t.string :address
      t.boolean :lost

      t.timestamps null: false
    end
  end
end
