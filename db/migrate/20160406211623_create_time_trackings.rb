class CreateTimeTrackings < ActiveRecord::Migration
  def change
    create_table :time_trackings do |t|
      t.references :user, index: true, foreign_key: true
      t.references :company, index: true, foreign_key: true
      t.decimal :spent_time
      t.decimal :hourly_rate
      t.date :date
      t.text :description

      t.timestamps null: false
    end
  end
end
