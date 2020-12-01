class Course < ApplicationRecord
  COURSE_PARAMS = [:name,
    :description,
    :status,
    :estimate_time,
    course_lecture_attributes: CourseLecture::COURSE_LECTURE_PARAMS].freeze
  enum status: {unactive: 0, active: 1, on_progress: 2, expired: 3}

  has_many :user_courses, dependent: :destroy
  has_many :instructor_courses, dependent: :destroy
  has_many :course_lecture, dependent: :destroy, inverse_of: :course
  has_many :course_categories, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :users, through: :user_courses, dependent: :destroy
  has_many :categories, through: :course_categories, dependent: :destroy

  validates :name, presence: true,
    length: {maximum: Settings.name.max_length,
             minimum: Settings.name.min_length}
  validates :description, presence: true,
    length: {maximum: Settings.description.max_length}
  validates :status, inclusion: {in: statuses.keys}

  accepts_nested_attributes_for :course_lecture,
                                reject_if: :all_blank,
                                allow_destroy: true

  scope :order_by_created_at, ->{order created_at: :desc}

  scope :by_name, (lambda do |name|
    where "LOWER(name) LIKE ?", "%#{name.downcase}%" if name.present?
  end)

  scope :by_description, (lambda do |description|
    return if description.blank?

    where "LOWER(description) LIKE ?", "%#{description.downcase}%"
  end)

  scope :by_created_date, (lambda do |start_date, end_date|
    return if start_date.blank? && end_date.blank?

    start_date = Settings.default_start_date if start_date.blank?
    end_date = Time.zone.today.strftime Settings.date_format if end_date.blank?
    where created_at: start_date..end_date
  end)

  scope :by_status, (lambda do |status|
    where status: status if status.present?
  end)

  scope :order_by_name, (lambda do |option|
    order name: option if option.present?
  end)

  scope :order_by_status, (lambda do |option|
    order status: option if option.present?
  end)
end
