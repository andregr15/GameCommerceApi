FactoryBot.define do
  factory :system_requirement do
    sequence(:name) { |n| "Basic #{n}" }
    operational_system { Faker::Computer.os }
    storage { "#{Faker::Number.within(range: 1..200)}GB" }
    processor { ['i5', 'Ryzen 5 3600X'].sample }
    memory { "#{Faker::Number.within(range: 2...32)}GB" }
    video_board { "N/A" }
  end
end
