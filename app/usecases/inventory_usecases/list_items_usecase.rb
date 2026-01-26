module InventoryUsecases
  class ListItemsUsecase
    def initialize(item_model: Item, category_model: Category)
      @item_model = item_model
      @category_model = category_model
    end
    def call(category_id: nil)
      base_scope = if category_id.present?
        @item_model.where(category_id: category_id)
      else
        @item_model.all
      end

      near_expiration_items = base_scope.near_expiration_items.includes(:category, :inventory_logs)
      other_items = base_scope.where.not(id: near_expiration_items.select(:id)).includes(:category, :inventory_logs)

      near_expiration_items + other_items
    end
  end
end
