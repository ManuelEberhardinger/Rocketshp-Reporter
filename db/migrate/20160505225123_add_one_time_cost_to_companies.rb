class AddOneTimeCostToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :one_time_cost, :integer
  end
end
