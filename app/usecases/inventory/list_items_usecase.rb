module Inventory
  class ListItemsUsecase
    def initialize(item_model: Item)
      @item_model = item_model
    end
    def call
      near_expiration_items = @item_model.near_expiration_items.includes(:category, :inventory_logs)
      other_items = @item_model.where.not(id: near_expiration_items.select(:id)).includes(:category, :inventory_logs)
      near_expiration_items + other_items
    end
  end
end
