require "rails_helper"

RSpec.describe Category, type: :model do
  let(:category) {FactoryBot.build :category}
  let(:invalid_category) {FactoryBot.build :category, name: nil}
  let!(:category_two) do
    FactoryBot.create :category,
                      name: "Math",
                      created_at: "29-11-2020".to_date,
                      updated_at: "29-11-2020".to_date
  end
  let!(:category_three) do
    FactoryBot.create :category,
                      name: "Programming",
                      description: "This is a sample description",
                      created_at: "30-11-2020".to_date,
                      updated_at: "30-11-2020".to_date
  end
  let!(:category_four) do
    FactoryBot.create :category,
                      name: "Art",
                      description: "This is not a sample description",
                      created_at: "01-12-2020".to_date,
                      updated_at: "01-12-2020".to_date
  end

  describe "Validations" do
    it "valid all fields" do
      expect(category.valid?).to eq true
    end

    it "invalid any fields" do
      expect(invalid_category.valid?).to eq false
    end
  end

  describe "Associations" do
    it {is_expected.to have_many :course_categories}
    it {is_expected.to have_many :courses}
  end

  describe ".order_by_created_at" do
    it "order by create at desc" do
      expect(Category.order_by_created_at.pluck(:created_at))
        .to eq ["01-12-2020".to_date,
                "30-11-2020".to_date,
                "29-11-2020".to_date]
    end
  end

  describe ".by_name" do
    it "by name" do
      expect(Category.by_name("Ar").pluck(:name))
        .to eq ["Art"]
    end
  end

  describe ".by_description" do
    it "by description" do
      expect(Category.by_description("not")).to include category_four
    end
  end
end
