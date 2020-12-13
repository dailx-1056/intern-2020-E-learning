require "rails_helper"

RSpec.describe UserCourse, type: :model do
  let(:user_course) {FactoryBot.build :user_course}
  let(:invalid_user_course) {FactoryBot.build :user_course, status: nil}
  let!(:user_course_learning) do
    FactoryBot.create :user_course, status: :learning,
                                    created_at: "29-11-2020".to_date,
                                    updated_at: "29-11-2020".to_date
  end
  let!(:user_course_pending) do
    FactoryBot.create :user_course, status: :pending,
                                    created_at: "30-11-2020".to_date,
                                    updated_at: "30-11-2020".to_date
  end
  let!(:user_course_not_allow) do
    FactoryBot.create :user_course, status: :not_allowed,
                                    created_at: "01-12-2020".to_date,
                                    updated_at: "01-12-2020".to_date
  end
  let!(:user_course_finish) do
    FactoryBot.create :user_course, status: :finish,
                                    created_at: "01-12-2020".to_date,
                                    updated_at: "01-12-2020".to_date
  end

  describe "Validations" do
    it "valid all fields" do
      expect(user_course.valid?).to eq true
    end

    it "invalid any fields" do
      expect(invalid_user_course.valid?).to eq false
    end
  end

  describe "Enums" do
    it "status" do
      is_expected.to define_enum_for(:status)
                 .with_values learning: 0, pending: 1, finish: 2, not_allowed: 3
    end
    it "relationship" do
      is_expected.to define_enum_for(:status)
                 .with_values student: 0, instructor: 1
    end
  end
end
