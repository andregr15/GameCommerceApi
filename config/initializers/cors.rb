Rails.application.config.middleware.insert_before 0, Rack::Cros do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [:get, :post, :put, :patch, :delete]
  end
end