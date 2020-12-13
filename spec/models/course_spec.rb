require "rails_helper"

RSpec.describe Course, type: :model do
  let(:course) {FactoryBot.build :course}
  let(:invalid_course) {FactoryBot.build :course, name: nil}
  let!(:course_two) do
    FactoryBot.create :course, status: :active,
                      name: "Luu Dai",
                      created_at: "29-11-2020".to_date,
                      updated_at: "29-11-2020".to_date
  end
  let!(:course_three) do
    FactoryBot.create :course, status: :unactive,
                      name: "Hoang Hai",
                      description: "This is a sample description",
                      created_at: "30-11-2020".to_date,
                      updated_at: "30-11-2020".to_date
  end
  let!(:course_four) do
    FactoryBot.create :course, status: :expired,
                      name: "Tran Tri",
                      description: "This is not a sample description",
                      created_at: "01-12-2020".to_date,
                      updated_at: "01-12-2020".to_date
  end

  describe "Validations" do
    it "valid all fields" do
      expect(course.valid?).to eq true
    end

    it "invalid any fields" do
      expect(invalid_course.valid?).to eq false
    end
  end

  describe "Associations" do
    it {is_expected.to have_many :users}
    it {is_expected.to have_many :course_lecture}
  end

  describe "Nested attributes" do
    it "course lecture" do
      is_expected.to accept_nested_attributes_for(:course_lecture)
                 .allow_destroy true
    end
  end

  describe "Enums" do
    it "status" do
      is_expected.to define_enum_for(:status)
                 .with_values unactive: 0, active: 1, expired: 3
    end
  end

  describe ".order_by_start_date" do
    it "order by start date desc" do
      expect(Course.order_by_created_at.pluck(:created_at))
        .to eq ["01-12-2020".to_date,
                "30-11-2020".to_date,
                "29-11-2020".to_date]
    end
  end

  describe ".order_by_status" do
    it "order by status asc" do
      expect(Course.order_by_status("asc").pluck(:status))
        .to eq %w(unactive active expired)
    end

    it "order by status desc" do
      expect(Course.order_by_status("desc").pluck(:status))
        .to eq %w(expired active unactive)
    end
  end

  describe ".order_by_name" do
    it "order by name asc" do
      expect(Course.order_by_name("asc").pluck(:name))
        .to eq ["Hoang Hai", "Luu Dai", "Tran Tri"]
    end

    it "order by name desc" do
      expect(Course.order_by_name("desc").pluck(:name))
        .to eq ["Tran Tri", "Luu Dai", "Hoang Hai"]
    end
  end

  describe ".by_name" do
    it "by name" do
      expect(Course.by_name("ai").pluck(:name))
        .to eq ["Luu Dai", "Hoang Hai"]
    end
  end

  describe ".by_description" do
    it "by description" do
      expect(Course.by_description("not")).to include course_four
    end
  end

  describe ".by_created_date" do
    it "by created date" do
      expect(Course.by_created_date("30/11/2020".to_date, "01/12/2020".to_date))
                   .to include course_three, course_four
    end
  end

  describe ".by_status" do
    it "by status active" do
      expect(Course.by_status("active"))
                   .to include course_two
    end

    it "by status unactive" do
      expect(Course.by_status("unactive"))
                   .to include course_three
    end

    it "by status expired" do
      expect(Course.by_status("expired"))
                   .to include course_four
    end
  end
end
