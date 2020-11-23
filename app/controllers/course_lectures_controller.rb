class CourseLecturesController < ApplicationController
  before_action :logged_in_user, only: :show
  before_action :get_course,
                :correct_learning_user,
                :get_course_lectures,
                only: %i(index show)

  def index; end

  def show
    if params[:method].eql? "next"
      next_lecture
    elsif params[:method].eql? "previous"
      previous_lecture
    else
      @course_lecture = @course.course_lecture.find_by number: params[:number]
      return unless not_learned? @course_lecture

      create_user_lecture
      redirect_to course_lectures_path unless @course_lecture
    end
  end

  private

  def next_lecture
    @course_lecture = @course.course_lecture
                             .get_next_number(params[:number])
                             .order_by_number
                             .first
    if @course_lecture.blank?
      flash[:success] = t "message.course.complete_course"
      redirect_to complete_courses_path
    else
      redirect_to course_lecture_path(id: @course_lecture.id,
                                      number: @course_lecture.number,
                                      course_id: params[:course_id])
    end
  end

  def previous_lecture
    @course_lecture = @course.course_lecture
                             .get_previous_number(params[:number])
                             .order_by_number
                             .last
    if @course_lecture.blank?
      flash[:success] = t "message.course.first_lecture"
      redirect_to course_lectures_path(course_id: params[:course_id])
    else
      redirect_to course_lecture_path(id: @course_lecture.id,
                          number: @course_lecture.number,
                          course_id: params[:course_id])
    end
  end

  def get_course
    @course = Course.find_by id: params[:course_id]
    return if @course

    flash[:danger] = t "message.course.not_found"
    redirect_to user_courses_path
  end

  def get_course_lectures
    @course_lectures = @course.course_lecture.order_by_number
  end

  def create_user_lecture
    user_lecture = UserLecture.new
    user_lecture.course_lecture_id = @course_lecture.id
    user_lecture.user_id = current_user.id
    user_lecture.status = UserLecture.statuses[:learned]

    if user_lecture.save
      flash[:success] = t "message.user_lecture.leaning_lecture"
    else
      flash[:danger] = t "message.user_lecture.cant_create"
    end
  end

  def correct_learning_user
    return if current_user &&
              (user_course(current_user, @course)&.learning? ||
              user_course(current_user, @course)&.finish?)

    flash[:danger] = t "message.user.require_login"
    redirect_to login_path
  end

  def not_learned? course_lecture
    current_user && user_lecture(current_user, course_lecture).nil?
  end
end
