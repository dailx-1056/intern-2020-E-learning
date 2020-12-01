FactoryBot.define do
  factory :course do
    name {Faker::Name.unique.name}
    status {Settings.status.active}
    description {Faker::Lorem.words(number: 4)}
    created_at {Faker::Date.between(from: "2019-11-23", to: "2020-01-25")}
  end
end
