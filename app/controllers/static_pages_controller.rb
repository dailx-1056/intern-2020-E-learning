class StaticPagesController < ApplicationController
  def index
    @courses = Course.active
                     .order_by_created_at
                     .page(params[:page])
                     .per Settings.user_course_per
  end
end
