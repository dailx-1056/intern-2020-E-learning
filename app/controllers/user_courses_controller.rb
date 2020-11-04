class UserCoursesController < ApplicationController
  include SessionsHelper

  def home
    @courses = Course.get_active_course
                     .page(params[:page])
                     .per Settings.user_course_per
  end

  def create
    if current_user
      @user_course = UserCourse.new
      @user_course.course_id = params[:course_id]
      @user_course.user_id = current_user.id
      @user_course.status = UserCourse.statuses[:learning]
      @user_course.relationship = UserCourse.relationships[:student]
      save_user_course
    else
      flash[:danger] = t "message.user.require_login"
      redirect_to login_path
    end
  end

  private

  def get_course
    @course = Course.find_by id: params[:course_id]
    return if @course

    redirect_to courses_path
  end

  def save_user_course
    if @user_course.save
      flash[:success] = t "message.enroll.success"
      redirect_to course_lectures_path(course_id: params[:course_id])
    else
      flash.now[:danger] = t "message.enroll.fail"
    end
  end
end
