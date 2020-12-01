FactoryBot.define do
  factory :category do
    name {Faker::Name.unique.name}
    description {Faker::Lorem.words(number: 4)}
  end
end
