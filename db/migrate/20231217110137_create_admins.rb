class CreateAdmins < ActiveRecord::Migration[7.0]
  def change
    create_table :admins do |t|
      t.string :name
      t.decimal :wallet_amount

      t.timestamps
    end
  end
end
