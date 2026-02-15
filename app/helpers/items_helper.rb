module ItemsHelper
  def display_quantity(quantity)
    quantity % 1 == 0 ? quantity.to_i : quantity
  end

  def item_highlight_class(item)
    item.expired_soon? ? "border-red-500" : "border-gray-100"
  end

  def expiration_date_class(item)
    item.expired_soon? ? "text-red-500 font-semibold" : "text-gray-600 font-normal"
  end

  def format_date(date)
    date&.strftime("%Y-%m-%d")
  end
end
