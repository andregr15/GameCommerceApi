FactoryBot.define do
  factory :system_requirement do
    sequence(:name) { |n| "Basic #{n}" }
    operational_system { Faker::Computer.os }
    storage { "#{Faker::Number.within(range: 1..200)}GB" }
    processor { ['i5 10600', 'i5 7400F', 'i3 6100', 'i3 7100F', 'Ryzen 3 3200', 'Ryzen 7 1700', 'Ryzen 5 3600X'].sample }
    memory { "#{Faker::Number.within(range: 2...32)}GB" }
    video_board { ['N/A', 'RTX 2060', 'RTX 2070', 'RX 5600XT', 'RX 5700XT'].sample }
  end
end
