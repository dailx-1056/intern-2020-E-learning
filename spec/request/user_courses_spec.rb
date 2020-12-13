require "rails_helper"

RSpec.describe UserCoursesController, type: :controller do
  let(:valid_params) {FactoryBot.attributes_for :user_course}
  let(:invalid_params) {FactoryBot.attributes_for :user_course, status: nil}
  let!(:user) {FactoryBot.create :user}
  let!(:category) {FactoryBot.create :category}
  let!(:category_one) {FactoryBot.create :category}
  let!(:category_two) {FactoryBot.create :category}
  let!(:course) {FactoryBot.create :course}
  let!(:course_category) {FactoryBot.create :course_category,
                                            course: course,
                                            category: category}

  before {login user}

  describe "GET #index" do
    context "when don't have category params" do
      before {get :index, params: {page: 1}}

      it "renders the 'index' template" do
        expect(response).to render_template :index
      end
    end

    context "when have category params" do
      before {get :index, params: {page: 1, category_id: category.id}}

      it "renders the 'index' template" do
        expect(response).to render_template :index
      end
    end
  end
end
