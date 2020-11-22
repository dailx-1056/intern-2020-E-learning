class User < ApplicationRecord
  USER_PARAMS = [:id,
                 :email,
                 :password,
                 :password_confirmation,
                 :user_detail,
                 :role_id,
                 user_detail_attributes: UserDetail::USER_DETAIL_PARAMS].freeze

  enum role: {admin: 0, user: 1, instructor: 2}

  has_one :user_detail, dependent: :destroy, inverse_of: :user
  has_many :user_courses, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :courses, through: :instructor_courses, dependent: :destroy
  has_many :courses, through: :user_courses, dependent: :destroy

  accepts_nested_attributes_for :user_detail, allow_destroy: true

  delegate :name, :birthday, :location, :status, to: :user_detail

  validates :email, presence: true,
    length: {maximum: Settings.email.max_length},
    format: {with: URI::MailTo::EMAIL_REGEXP},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.password.min_length},
    allow_nil: true
  validates :role, inclusion: {in: roles.keys}

  has_secure_password

  before_save :downcase_email

  scope :by_email, (lambda do |email|
    where "LOWER(users.email) LIKE ?", "%#{email.downcase}%" if email.present?
  end)
  scope :by_name, (lambda do |name|
    return if name.blank?

    where "LOWER(user_details.name) LIKE ?", "%#{name.downcase}%"
  end)
  scope :by_location, (lambda do |location|
    return if location.blank?

    where "LOWER(users.location) LIKE ?", "%#{location.downcase}%"
  end)
  scope :by_role, (lambda do |role|
    where role: role if role.present?
  end)
  scope :by_birthday, (lambda do |start_date, end_date|
    return if start_date.blank? && end_date.blank?

    start_date = Settings.default_start_date if start_date.blank?
    end_date = Time.zone.today.strftime Settings.date_format if end_date.blank?
    where "user_details.birthday BETWEEN ? AND ?", start_date, end_date
  end)

  private

  def downcase_email
    email.downcase!
  end
end
