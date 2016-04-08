class AddTotalHoursToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :total_hours, :decimal
  end
end
