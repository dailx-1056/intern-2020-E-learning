FactoryBot.define do
  factory :user do
    email {Faker::Internet.unique.email}
    password {"123456"}
    role {Faker::Number.between from: 0, to: 2}
    created_at {Faker::Date.between(from: "2019-11-23", to: "2020-01-25")}
  end
end