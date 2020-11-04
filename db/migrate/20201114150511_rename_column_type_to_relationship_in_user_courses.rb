class RenameColumnTypeToRelationshipInUserCourses < ActiveRecord::Migration[6.0]
  def change
    rename_column :user_courses, :type, :relationship
  end
end
