class AddCompanyRefToPosts < ActiveRecord::Migration
  def change
    add_reference :posts, :company, index: true, foreign_key: true
  end
end
