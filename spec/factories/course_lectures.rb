FactoryBot.define do
  factory :course_lecture do
    course
    name {Faker::Name.unique.name}
    number {Faker::Number.unique.digit}
    video_link {Faker::Internet.url}
  end
end
