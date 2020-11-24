class Admin::CoursesController < Admin::BaseController
  before_action :get_course, only: %i(edit update)
  before_action :store_previous_page, only: %i(new edit)

  load_and_authorize_resource

  def index
    @q = Course.ransack params[:q], auth_object: set_ransackable_auth_object
    @courses = @q.result
                 .order_by_created_at
                 .page(params[:page])
                 .per Settings.per
  end

  def new
    @course = Course.new
    @course.course_lecture.build
  end

  def create
    @course = Course.new course_params
    if @course.save
      flash[:success] = t "message.course.create_success"
      redirect_to admin_courses_path
    else
      flash.now[:danger] = t "message.course.create_fail"
      render :new
    end
  end

  def edit
    @course.course_lecture.build if @course.course_lecture.blank?
    @users = @course.users
                    .includes(:user_detail, :user_courses)
                    .by_course_id(@course.id)
                    .page(params[:page])
                    .per Settings.per
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

  private

  def course_params
    params.require(:course).permit Course::COURSE_PARAMS
  end

  def get_course
    @course = Course.find_by id: params[:id]
    return if @course

    flash[:danger] = t "message.course.not_found"
    redirect_to admin_courses_path
  end

  def store_previous_page
    session[:back_path] = request.referer
  end
end
