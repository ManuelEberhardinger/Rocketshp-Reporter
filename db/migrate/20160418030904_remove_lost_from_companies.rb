class RemoveLostFromCompanies < ActiveRecord::Migration
  def change
    remove_column :companies, :lost, :boolean
  end
end
