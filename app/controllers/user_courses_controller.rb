class UserCoursesController < ApplicationController
  before_action :logged_in_user, only: %i(create)
  before_action :get_course_by_user_course, :get_courses, only: :index

  def index
    @courses = @courses.active
                       .by_ids(@course_id)
                       .page(params[:page])
                       .per Settings.user_course_per
  end

  def new
    @course = Course.find_by id: params[:course_id]
    get_course_lectures
    return unless current_user

    @user_course = UserCourse.find_by course_id: params[:course_id],
                                      user_id: current_user.id
    return unless @user_course&.learning?

    flash[:success] = t "message.course.welcome_back"
    redirect_to course_lectures_path(course_id: params[:course_id])
  end

  def create
    create_student_course_relationship
    if @user_course.save
      flash[:warning] = t "message.enroll.wait"
      redirect_to user_courses_url
    else
      flash.now[:danger] = t "message.enroll.fail"
    end
  end

  private

  def create_student_course_relationship
    @user_course = UserCourse.new
    @user_course.course_id = params[:course_id]
    @user_course.user_id = current_user.id
    @user_course.status = UserCourse.statuses[:pending]
    @user_course.relationship = UserCourse.relationships[:student]
  end

  def get_courses
    @courses = Course.by_name(params[:text_search])
                     .by_description(params[:text_search])
  end

  def get_course_by_user_course
    return if params[:status].blank?

    @course_id = UserCourse.by_user_id(current_user.id)
                           .by_status(params[:status])
                           .pluck(:course_id)
                           .uniq
  end

  def user_course_params
    params.require(:user_course).permit UserCourse::USER_COURSE_PARAMS
  end

  def get_course_lectures
    if @course
      @course_lectures = @course.course_lecture
    else
      flash[:danger] = t "message.course.not_found"
      redirect_to user_courses_path
    end
  end
end
