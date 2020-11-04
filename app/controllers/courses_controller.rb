class CoursesController < ApplicationController
  include SessionsHelper

  before_action :get_course, only: %i(edit update)
  before_action :store_previous_page, only: %i(new edit)

  def index
    @courses = Course.order_by_created_at.page(params[:page]).per Settings.per
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new course_params
    if @course.save
      flash[:info] = t "message.course.create_success"
      redirect_to courses_path
    else
      flash.now[:danger] = t "message.course.create_fail"
      render :new
    end
  end

  def update
    if @course.update course_params
      flash[:success] = t "message.course.update_success"
      redirect_to session.delete(:back_path) || request.referer
    else
      flash.now[:danger] = t "message.course.update_fail"
      render :edit
    end
  end

  def edit
    @lectures = @course.course_lecture.order_by_number
    @users = @course.users
                    .joins(:user_detail)
                    .page(params[:page]).per Settings.per
  end

  def destroy
    @course.status = Course.statuses[:expired]
    if @course.save
      flash[:info] = t "message.course.create_success"
      redirect_to courses_path(page: params[:page])
    else
      flash.now[:danger] = t "message.course.create_fail"
    end
  end

  def show
    return unless current_user\
      && current_user.user_courses.pluck(:course_id).include?(params[:id].to_i)

    flash[:success] = t "message.course.welcome_back"
    redirect_to course_lectures_path(course_id: params[:id])
  end

  private

  def course_params
    params.require(:course).permit Course::COURSE_PARAMS
  end

  def get_course
    @course = Course.find_by id: params[:id]
    return if @course

    flash[:danger] = t "message.course.not_found"
    redirect_to courses_path
  end

  def store_previous_page
    session[:back_path] = request.referer
  end
end
