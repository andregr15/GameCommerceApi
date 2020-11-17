FactoryBot.define do
  factory :coupon do
    sequence(:name) { |n| "My Coupon #{n}" }
    code { Faker::Commerce.unique.promotion_code(digits: 4) }
    status { %i(active inactive).sample }
    discount_value { Faker::Number.within(range: 5...75) }
    max_use { Faker::Number.within(range: 1...10) }
    due_date { Faker::Date.forward(days: 10) }
  end
end
