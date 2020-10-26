class CreateCourses < ActiveRecord::Migration[6.0]
  def change
    create_table :courses do |t|
      t.string :code
      t.string :name
      t.text :description
      t.integer :status
      t.date :estimate_time

      t.timestamps
    end
  end
end
