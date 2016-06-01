class AddGoogleAdwordsIdToSocialIds < ActiveRecord::Migration
  def change
    add_column :social_ids, :google_adwords_id, :string
  end
end
