class CourseLecturesController < ApplicationController
  before_action :get_course, only: %i(index
    show next_lecture previous_lecture)

  def index
    @course_lectures = @course.course_lecture
                              .order_by_number
                              .page(params[:page])
                              .per Settings.per
  end

  def show
    @lecture = @course.course_lecture.find_by number: params[:number]
    redirect_to courses_path unless @lecture
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
      redirect_to
      course_lecture_path(id: @course_lecture.id,
                          number: @lecture.number,
                          course_id: params[:course_id])
    end
  end

  private

  def get_course
    @course = Course.find_by id: params[:course_id]
    return if @course

    redirect_to courses_path
  end
end
