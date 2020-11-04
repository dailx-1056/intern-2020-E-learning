class CoursesController < ApplicationController
  include SessionsHelper

  before_action :get_courses, only: :index
  before_action :get_course, only: %i(edit update show)
  before_action :store_previous_page, only: %i(new edit)

  def index
    @courses = @courses.order_by_created_at
                       .page(params[:page])
                       .per Settings.per
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

  def show
    return unless current_user&.user_courses&.enrolled(params[:id])

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

  def get_courses
    @courses = Course.by_name(params[:name])
                     .by_description(params[:description])
                     .by_created_date(params[:start_date], params[:end_date])
                     .by_status(params[:status])
  end
end
