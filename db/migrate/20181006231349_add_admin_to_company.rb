class AddAdminToCompany < ActiveRecord::Migration[5.2]
  def change
    add_reference :companies, :admin, foreign_key: true
  end
end
