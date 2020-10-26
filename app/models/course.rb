class Course < ApplicationRecord
  has_and_belongs_to_many :categories
  has_many :user_courses
  has_many :instructor_courses
  has_many :course_lectures
  has_many :comments
  has_many :courses, through :user_courses
end
