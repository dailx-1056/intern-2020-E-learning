class UserCoursesController < ApplicationController
  before_action :logged_in_user,
                :create_student_course_params,
                only: %i(create new)
  before_action :get_course_and_course_lectures, only: :new
  before_action :get_courses_by_category,
                :get_categories,
                only: :index

  def index
    course_learned_ids = current_user&.courses&.pluck :id
    @courses = Course.active
                     .exclude_ids(course_learned_ids)
                     .by_ids(@course_id)
                     .page(params[:page])
                     .per Settings.user_course_per
  end

  def new
    @course = Course.find params[:course_id]
    @user_course = current_user.user_courses
                               .find_by course_id: params[:course_id]
    create_comment_and_get_comments @course
    return unless @user_course&.learning?

    flash[:success] = t "message.course.welcome_back"
    redirect_to course_lectures_path(course_id: params[:course_id])
  end

  def create
    user_course = UserCourse.new user_course_params
    if user_course.save
      flash[:warning] = t "message.enroll.wait"
      redirect_to my_courses_path(status: Settings.status.pending)
    else
      flash.now[:danger] = t "message.enroll.fail"
      redirect_to new_user_course_path(course_id: params[:course_id])
    end
  end

  private

  def get_courses_by_category
    return if params[:category_id].blank?

    @course_id = CourseCategory.by_category_id(params[:category_id])
                               .pluck(:course_id)
                               .uniq
  end

  def user_course_params
    params.require(:user_course).permit UserCourse::USER_COURSE_PARAMS
  end

  def create_student_course_params
    params.merge! user_course:
      {course_id: params[:course_id],
       user_id: current_user.id,
       status: UserCourse.statuses[:pending],
       relationship: UserCourse.relationships[:student]}
  end

  def get_course_and_course_lectures
    @course = Course.find_by id: params[:course_id]
    if @course
      @course_lectures = @course.course_lecture
    else
      flash[:danger] = t "message.course.not_found"
      redirect_to user_courses_path
    end
  end

  def get_categories
    @categories = Category.order_by_created_at.limit Settings.limit_newest_cate
  end
end
