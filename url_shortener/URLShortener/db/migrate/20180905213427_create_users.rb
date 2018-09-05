class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.timestamps
      t.string :email, null: false
    end
    
    add_index :users, :email
    
  end
end
