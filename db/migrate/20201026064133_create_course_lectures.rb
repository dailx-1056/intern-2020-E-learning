class CreateCourseLectures < ActiveRecord::Migration[6.0]
  def change
    create_table :course_lectures do |t|
      t.string :name
      t.integer :number
      t.string :video_link
      t.references :course, null: false, foreign_key: true

      t.timestamps
    end
  end
end
