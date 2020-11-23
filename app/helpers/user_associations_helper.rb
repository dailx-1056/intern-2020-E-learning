module UserAssociationsHelper
  def user_course user, course
    @user_course = UserCourse.find_by user_id: user.id, course_id: course.id
  end

  def user_lecture user, course_lecture
    @user_lecture = UserLecture.find_by user_id: user.id,
                                        course_lecture_id: course_lecture.id
  end

  def user_lectures user, course
    course_lecture_ids = CourseLecture.by_course_id(course.id).pluck(:id)
    @user_lectures = UserLecture.by_user_id(user.id)
                                .by_course_lecture_ids course_lecture_ids
  end
end
