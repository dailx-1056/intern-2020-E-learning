class Course < ApplicationRecord
  COURSE_PARAMS = [:name,
    :description,
    :status,
    :estimate_time,
    course_lecture_attributes: CourseLecture::COURSE_LECTURE_PARAMS].freeze
  enum status: {unactive: 0, active: 1, on_progress: 2, expired: 3}

  has_many :categories, through: :course_categories, dependent: :destroy
  has_many :user_courses, dependent: :destroy
  has_many :instructor_courses, dependent: :destroy
  has_many :course_lecture, dependent: :destroy, inverse_of: :course
  has_many :course_categories, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :users, through: :user_courses, dependent: :destroy
  has_many :categories, through: :course_categories, dependent: :destroy

  validates :status, inclusion: {in: statuses.keys}

  accepts_nested_attributes_for :course_lecture,
                                reject_if: :all_blank,
                                allow_destroy: true

  scope :order_by_created_at, ->{order created_at: :desc}
  scope :get_active_course, ->{where status: Course.statuses[:active]}
end
