json.coupons do
  json.array! @coupons, :name, :code, :status, :discount_value, :due_date
end