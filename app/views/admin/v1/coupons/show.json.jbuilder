json.coupon do
  json.(@coupon, :name, :code, :status, :discount_value, :due_date)
end