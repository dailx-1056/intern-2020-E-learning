require "rails_helper"

RSpec.describe MyCoursesController, type: :controller do
  let!(:user) {FactoryBot.create(:user)}
  let!(:other_user) {FactoryBot.create(:user)}
  let(:course) {FactoryBot.create(:course)}
  let(:course_two) {FactoryBot.create(:course)}
  let(:course_three) {FactoryBot.create(:course)}
  let!(:user_course_one) do
    FactoryBot.create(:user_course,
    user: user,
    course: course)
  end
  let!(:user_course_two) do
    FactoryBot.create(:user_course,
    user: user,
    course: course_two)
  end
  let!(:user_course_three) do
    FactoryBot.create(:user_course,
    user: other_user,
    course: course_three)
  end

  before {login user}

  describe "GET #index" do
    before {get :index, params: {page: 1}}

    it "should load courses belongs to user" do
      expect(assigns(:courses).pluck(:id)).to eq [course.id,  course_two.id]
    end

    it "should render 'index' template" do
      expect(response).to render_template :index
    end
  end
end
