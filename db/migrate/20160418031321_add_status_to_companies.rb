class AddStatusToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :status, :integer
  end
end
