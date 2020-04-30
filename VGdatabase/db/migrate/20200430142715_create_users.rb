class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :username
      t.string :password
      t.string :avatar
      t.string :background
      t.string :location
      t.string :social1
      t.string :social2
      t.string :social3
    end
  end
end
