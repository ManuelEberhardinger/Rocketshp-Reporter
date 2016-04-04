class CreateSocialIds < ActiveRecord::Migration
  def change
    create_table :social_ids do |t|
      t.references :company, index: true, foreign_key: true
      t.string :facebook_id
      t.string :google_analytics_id
      t.string :linkedin_id

      t.timestamps null: false
    end
  end
end
