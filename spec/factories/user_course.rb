FactoryBot.define do
  factory :user_course do
    course
    user
    status {Settings.status.pending}
    relationship {"student"}
  end
end
