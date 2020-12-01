FactoryBot.define do
  factory :course_lecture do
    name {Faker::Name.unique.name}
    number {Faker::Number.digit}
    video_link {Faker::Internet.url}
  end
end
