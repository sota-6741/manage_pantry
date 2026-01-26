# Categories
categories = [
  { name: "野菜" },
  { name: "肉・魚" },
  { name: "乳製品・卵" },
  { name: "調味料" },
  { name: "飲み物" },
  { name: "その他" }
]

categories.each do |cat|
  Category.find_or_create_by!(name: cat[:name])
end

# Items
pantry_items = [
  { name: "キャベツ", quantity: 1, expiration_date: 3.days.from_now.to_date, category_name: "野菜" },
  { name: "鶏肉", quantity: 2, expiration_date: 1.day.from_now.to_date, category_name: "肉・魚" },
  { name: "牛乳", quantity: 1, expiration_date: 5.days.from_now.to_date, category_name: "乳製品・卵" },
  { name: "醤油", quantity: 1, expiration_date: 100.days.from_now.to_date, category_name: "調味料" },
  { name: "コーラ", quantity: 3, expiration_date: 10.days.from_now.to_date, category_name: "飲み物" },
  { name: "納豆", quantity: 3, expiration_date: 2.days.ago.to_date, category_name: "乳製品・卵" } # 期限切れ
]

pantry_items.each do |item_data|
  category = Category.find_by(name: item_data[:category_name])
  Item.find_or_create_by!(name: item_data[:name]) do |item|
    item.quantity = item_data[:quantity]
    item.expiration_date = item_data[:expiration_date]
    item.category = category
  end
end
