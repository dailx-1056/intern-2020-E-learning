class Admin::CoursesController < Admin::BaseController
  before_action :get_courses,
                :get_course_has_pending_user,
                :order_course,
                only: :index
  before_action :get_course, only: %i(edit update)
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
      redirect_to admin_courses_path
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
    @users = @course.users.left_outer_joins(:user_detail)
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

  def get_courses
    @courses = Course.by_name(params[:name])
                     .by_description(params[:description])
                     .by_created_date(params[:start_date], params[:end_date])
                     .by_status(params[:status])
  end

  def order_course
    @courses = @courses.order_by_name(params[:name_option])
                       .order_by_status(params[:status_option])
  end

  def get_course_has_pending_user
    return unless params[:pending]

    course_ids = UserCourse.by_status("pending").pluck(:course_id).uniq
    @courses = @courses.by_ids course_ids
  end
end
