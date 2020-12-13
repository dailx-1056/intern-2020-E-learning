require "rails_helper"

RSpec.describe CourseLecturesController, type: :controller do
  let(:valid_params) {FactoryBot.attributes_for :course_lecture}
  let(:invalid_params) {FactoryBot.attributes_for :course_lecture, number: nil}
  let!(:user) {FactoryBot.create :user}
  let!(:course) {FactoryBot.create :course}
  let!(:course_lecture) {FactoryBot.create :course_lecture, number: 1, course: course}
  let!(:course_lecture_two) {FactoryBot.create :course_lecture, number: 2, course: course}
  let!(:course_lecture_three) {FactoryBot.create :course_lecture, number: 3, course: course}
  let!(:user_course) {FactoryBot.create :user_course, user: user, course: course, status: "learning"}
  let!(:user_lecture) {FactoryBot.create :user_lecture, user: user, course_lecture: course_lecture}

  before {login user}

  describe "GET #index" do
    before {get :index, params: {course_id: course.id}}

    it "renders the 'index' template" do
      expect(response).to render_template :index
    end

    it "assigns @course_lectures" do
      expect(assigns(:course_lectures).pluck(:id)).to eq [course_lecture.id,
                                                          course_lecture_two.id,
                                                          course_lecture_three.id]
    end

    context "when user not allow to learn" do
      let(:course_two) {FactoryBot.create :course}
      let(:user_course_two) {FactoryBot.create :user_course, user: user, course: course_two}
      before {get :index, params: {course_id: course_two.id}}

      it "not renders the 'show' template" do
        expect(response).not_to render_template :index
      end
    end

    context "when course not found" do
      before {get :index, params: {course_id: 1900}}

      it "renders the 'show' template" do
        expect(response).to redirect_to user_courses_path
      end

      it "should return danger message" do
        expect(flash[:danger]).to eq I18n.t("message.course.not_found")
      end
    end
  end

  describe "GET #show" do
    context "when show select lecture" do
      before {get :show, params: {id: course_lecture.id,
                                  number: course_lecture.number,
                                  course_id: course.id}}

      it "renders the 'show' template" do
        expect(response).to render_template :show
      end

      it "assigns @course_lecture" do
        expect(assigns(:course_lecture).id).to eq course_lecture.id
      end
    end

    context "when show next lecture" do
      before {get :show, params: {id: course_lecture.id,
                                  method: "next",
                                  number: course_lecture.number,
                                  course_id: course.id}}

      it "assigns @course_lecture" do
        expect(assigns(:course_lecture).id).to eq course_lecture_two.id
      end
    end

    context "when current lecture is the last" do
      before {get :show, params: {id: course_lecture_three.id,
                                method: "next",
                                number: course_lecture_three.number,
                                course_id: course.id}}

      it "should return success message" do
        expect(flash[:success]).to eq I18n.t("message.course.complete_course")
      end
    end

    context "when show previous lecture" do
      before {get :show, params: {id: course_lecture_two.id,
                                  method: "previous",
                                  number: course_lecture.number,
                                  course_id: course.id}}

      it "assigns @course_lecture" do
        expect(assigns(:course_lecture_two).id).to eq course_lecture.id
      end
    end
  end
end
