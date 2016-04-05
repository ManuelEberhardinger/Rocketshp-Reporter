class RemovePredictingValueFromCompanies < ActiveRecord::Migration
  def change
    remove_column :companies, :predicting_value, :integer
  end
end
