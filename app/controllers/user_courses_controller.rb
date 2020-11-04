class UserCoursesController < ApplicationController
  before_action :logged_in_user, only: %i(create)

  def index
    @courses = Course.active
                     .page(params[:page])
                     .per Settings.user_course_per
  end

  def create
    create_student_course_relationship
    if @user_course.save
      flash[:success] = t "message.enroll.success"
      redirect_to course_lectures_path(course_id: params[:course_id])
    else
      flash.now[:danger] = t "message.enroll.fail"
    end
  end

  private

  def create_student_course_relationship
    @user_course = UserCourse.new
    @user_course.course_id = params[:course_id]
    @user_course.user_id = current_user.id
    @user_course.status = UserCourse.statuses[:learning]
    @user_course.relationship = UserCourse.relationships[:student]
  end
end
