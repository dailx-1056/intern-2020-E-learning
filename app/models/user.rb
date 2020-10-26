class User < ApplicationRecord
  has_one :user_details
  has_many :user_courses
  has_many :comments
  has_many :instructor_courses
  has_many :courses, through :user_courses
end
