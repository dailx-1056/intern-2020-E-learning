FactoryBot.define do
  factory :user do
    email {Faker::Internet.unique.email}
    password {"123456"}
    role {Faker::Number.between from: 0, to: 2}
  end
end
