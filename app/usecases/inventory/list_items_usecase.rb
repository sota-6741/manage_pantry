# app/usecases/inventory/list_items_usecase.rb
module Inventory
  class ListItemsUsecase
    def call
      near_expiration_items = Item.near_expiration_items
      other_items = Item.where.not(id: near_expiration_items.select(:id))
      near_expiration_items + other_items
    end
  end
end
