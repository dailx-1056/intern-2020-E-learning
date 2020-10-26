class CreateUserDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :user_details do |t|
      t.string :name
      t.datetime :birthday
      t.string :location
      t.string :avatar
      t.string :workplace
      t.integer :status
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
