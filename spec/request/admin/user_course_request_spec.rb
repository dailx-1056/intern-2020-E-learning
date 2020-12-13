require "rails_helper"

RSpec.describe Admin::UserCoursesController, type: :controller do
  let(:valid_params) {FactoryBot.attributes_for :user_course, description: "blabla"}
  let(:invalid_params) {FactoryBot.attributes_for :user_course, status: nil}
  let!(:user) {FactoryBot.create :user, role: :admin}
  let!(:normal_user) {FactoryBot.create :user, email: "example@email.com"}
  let!(:course) {FactoryBot.create :course}
  let!(:user_course) {FactoryBot.create :user_course, user: user, course: course}

  before {login user}

  describe "PATCH #update" do
    context "when valid params" do
      before {patch :update,
              xhr: true,
              params: {id: user_course.id,
                       user_course: {status: "finish"}},
              session: {back_path: admin_user_courses_path}}

      it "should correct status" do
        expect(flash[:success]).to eq I18n.t("message.user_course.update_success")
      end

      context "when update all" do
        before {patch :update,
                xhr: true,
                params: {id: user_course.id,
                         course_id: course.id,
                         status: %w(pending),
                         user_course: {status: "learning"},
                         all: "all"}}

        it "should correct status" do
          expect(flash[:success]).to eq I18n.t("message.user_course.update_success")
        end

        context "when course not found" do
          before {patch :update,
                xhr: true,
                params: {id: user_course.id,
                         course_id: 1990,
                         status: %w(pending),
                         user_course: {status: "learning"},
                         all: "all"}}

          it "should return danger message" do
            expect(flash[:danger]).to eq I18n.t("message.user_course.update_fail")
          end
        end
      end
    end

    context "when invalid params" do
      before {patch :update,
              xhr: true,
              params: {id: user_course.id, user_course: invalid_params}}

      it "should incorrect status" do
        expect(flash[:danger]).to eq I18n.t("message.user_course.update_fail")
      end
    end
  end
end
