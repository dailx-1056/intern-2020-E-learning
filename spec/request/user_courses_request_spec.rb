require "rails_helper"

RSpec.describe UserCoursesController, type: :controller do
  let!(:user) {FactoryBot.create :user}
  let(:course) {FactoryBot.create :course}
  let(:course_two) {FactoryBot.create :course}
  let(:course_three) {FactoryBot.create :course}
  let!(:course_four) {FactoryBot.create :course}
  let!(:course_five) {FactoryBot.create :course}
  let!(:user_course) do
    FactoryBot.create :user_course,
    user: user,
    course: course
  end
  let!(:user_course_two) do
    FactoryBot.create :user_course,
    user: user,
    course: course_two,
    status: Settings.status.learning
  end
  let!(:user_course_three) do
    FactoryBot.create :user_course,
    user: user,
    course: course_three
  end

  before {login user}

  describe "GET #index" do
    before {get :index, params: {page: 1}}

    it "renders the 'index' template" do
      expect(response).to render_template :index
    end

    it "load all courses" do
      expect(assigns(:courses).pluck(:id)).to eq [course_four.id,
                                                  course_five.id]
    end

    context "when filter by categories" do
      let(:category) {FactoryBot.create :category}
      let!(:course_six) {FactoryBot.create :course, categories: [category]}

      before {get :index, params: {page: 1, category_id: category.id}}

      it "should load course that have specific category" do
        expect(assigns(:courses).pluck(:id)).to eq [course_six.id]
      end
    end
  end

  describe "GET #new" do
    context "when user not approved" do
      before {get :new, params: {course_id: course.id}}

      it "should get correct course" do
        expect(assigns(:course).id).to eq course.id
      end

      it "should get correct user_course" do
        expect(assigns(:user_course).id).to eq user_course.id
      end

      it "should render new template" do
        expect(response).to render_template :new
      end
    end

    context "when user already approved" do
      before {get :new, params: {course_id: course_two.id}}

      it "should return success message" do
        expect(flash[:success]).to eq I18n.t("message.course.welcome_back")
      end

      it "should rendirect to course lectures path" do
        expect(response).to redirect_to course_lectures_path(course_id: course_two.id)
      end
    end

    context "when wrong course id" do
      before {get :new, params: {course_id: 90000}}

      it "should return danger message" do
        expect(flash[:danger]).to eq I18n.t("message.course.not_found")
      end

      it "should rendirect to course lectures path" do
        expect(response).to redirect_to user_courses_path
      end
    end
  end

  describe "POST #create" do
    context "when valid params" do
      before {post :create, params: {course_id: course.id}}

      it "has a 200 status code" do
        response.code.should.eql? "200"
      end
    end

    context "when invalid params" do
      before {post :create, params: {course_id: 1900}}

      it "has a 310 status code" do
        response.code.should.eql? "301"
      end
    end
  end
end
