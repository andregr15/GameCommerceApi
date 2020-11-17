FactoryBot.define do
  factory :game do
    mode { %i(pvp pve both).sample }
    release_date { Faker::Date.between(from: '2000-01-01', to: '2020-12-31') }
    developer { Faker::Company.name }
    system_requirement
  end
end
