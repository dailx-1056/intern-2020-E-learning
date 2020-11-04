class UserCourse < ApplicationRecord
  belongs_to :user
  belongs_to :course
  enum status: {learning: 0, pending: 1, finish: 2}
  enum relationship: {student: 0, instructor: 1}

  validates :user_id, presence: true
  validates :course_id, presence: true
  # validates :start_time, presence: true
  # validates :end_time, presence: true
  validates :status, inclusion: {in: statuses.keys}
  validates :relationship, inclusion: {in: relationships.keys}
end
