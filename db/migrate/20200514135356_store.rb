class Store < ActiveRecord::Migration[5.2]
  def change
    create_table :stores do |t|
        t.references 'game'
        t.references 'user'
        t.string 'selling'
        t.string 'condition'
        t.integer 'price'
    end
  end
end
