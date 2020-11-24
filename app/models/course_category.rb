class CourseCategory < ApplicationRecord
  belongs_to :course
  belongs_to :category

  scope :by_category_id, (lambda do |category_id|
    where category_id: category_id if category_id.present?
  end)
end
