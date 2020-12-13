require "rails_helper"

RSpec.describe Admin::CoursesController, type: :controller do
  let(:valid_params) {FactoryBot.attributes_for :course,
                      description: "blabla",
                      status: "active"}
  let(:invalid_params) {FactoryBot.attributes_for :course,
                        name: nil,
                        status: "active"}
  let!(:course) {FactoryBot.create :course}
  let!(:course_two) {FactoryBot.create :course}
  let!(:course_three) {FactoryBot.create :course}
  let!(:user) {FactoryBot.create :user, role: :admin}

  before {login user}

  describe "GET #index" do
    before {get :index, params: {page: 1}}

    it "renders the 'index' template" do
      expect(response).to render_template :index
    end

    it "assigns @courses" do
      expect(assigns(:courses).pluck(:id)).to eq [course_three.id, course_two.id, course.id]
    end
  end

  describe "GET #new" do
    let!(:course_new) {FactoryBot.create :course}
    before {get :new}
    it "should render new template" do
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    context "when valid params" do
      before {post :create, params: {course: valid_params}}

      it "should redirect to admin_courses_path" do
        expect(response).to redirect_to admin_courses_path
      end

      it "should return success message" do
        expect(flash[:success]).to eq I18n.t("message.course.create_success")
      end
    end

    context "when invalid params" do
      before {post :create, params: {course: invalid_params}}

      it "should return danger message" do
        expect(flash[:danger]).to eq I18n.t("message.course.create_fail")
      end
    end
  end

  describe "GET #edit" do
    context "when valid params" do
      before {get :edit, params: {id: course.id}}

      it "should have a valid course" do
        expect(assigns(:course).id).to eq course.id
      end
    end

    context "when invalid params" do
      before {get :edit, params: {id: "string"}}

      it "should have a invalid course" do
        expect(assigns(:course)).to eq nil
      end
    end
  end

  describe "PATCH #update" do
    context "when valid params" do
      before {patch :update,
              params: {id: course.id, course: {name: "Test update"}},
              session: {back_path: admin_courses_path}}

      it "should correct name" do
        expect(assigns(:course).name).to eq "Test update"
      end

      it "should redirect admin_courses_path" do
        expect(response).to redirect_to admin_courses_path
      end
    end

    context "when invalid params" do
      before { patch :update, params: {id: course.id, course: invalid_params} }

      it "should a invalid course" do
        expect(assigns(:course).invalid?).to eq true
      end

      it "should render edit template" do
        expect(response).to render_template :edit
      end
    end
  end
end
