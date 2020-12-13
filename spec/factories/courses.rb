FactoryBot.define do
  factory :course do
    name {Faker::Name.unique.name}
    status {Settings.status.active}
    description {Faker::Lorem.words(number: 4)}
  end
end
