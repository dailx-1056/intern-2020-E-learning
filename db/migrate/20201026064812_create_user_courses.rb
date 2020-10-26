class CreateUserCourses < ActiveRecord::Migration[6.0]
  def change
    create_table :user_courses do |t|
      t.date :start_time
      t.date :end_time
      t.integer :status
      t.integer :type
      t.references :user, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true
    end
  end
end
