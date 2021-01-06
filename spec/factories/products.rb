FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product #{n}" }
    description { Faker::Lorem.paragraph }
    price { Faker::Commerce.price(range: 5.0...400.0) }

    # class code gives ActiveStorage::IntegridError on tests and seeds
    # image { Rack::Test::UploadedImage.new(Rails.root.join('spec/support/images/product_image.png')) }

    after :build do |product|
      product.productable = create(:game)

      # work around ActiveStorage::IntegridError caused by class code
      product.image.attach(
        io: File.open(Rails.root.join('spec/support/images/product_image.png')),
        filename: 'product_image',
        content_type: 'image/png'
      )
    end
  end
end
