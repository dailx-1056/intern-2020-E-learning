class CourseLecturesController < ApplicationController
  before_action :get_course, only: %i(index show)
  before_action :get_course_lectures, only: %i(index show)

  def index; end

  def show
    if params[:method] == "next"
      next_lecture
    elsif params[:method] == "previous"
      previous_lecture
    else
      @course_lecture = @course.course_lecture.find_by number: params[:number]
      redirect_to course_lectures_path unless @course_lecture
    end
  end

  private

  def get_course
    @course = Course.find_by id: params[:course_id]
    return if @course

    flash[:danger] = t "message.course.not_found"
    redirect_to courses_path
  end

  def get_course_lectures
    @course_lectures = @course.course_lecture
                              .order_by_number
                              .page(params[:page])
                              .per Settings.per
  end

  def next_lecture
    @course_lecture = @course.course_lecture
                             .get_next_number(params[:number])
                             .order_by_number
                             .first
    if @course_lecture.blank?
      flash[:success] = t "message.course.complete_course"
      redirect_to course_lectures_path(course_id: params[:course_id])
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
      flash[:success] = t "message.course.first_course"
      redirect_to course_lectures_path(course_id: params[:course_id])
    else
      redirect_to course_lecture_path(id: @course_lecture.id,
                          number: @course_lecture.number,
                          course_id: params[:course_id])
    end
  end
end
