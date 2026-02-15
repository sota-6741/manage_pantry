module InventoryUsecases
  class ListItemsUsecase
    def initialize(item_model: Item, category_model: Category)
      @item_model = item_model
      @category_model = category_model
    end

    def call(user:, category_id: nil)
      base_scope = user.items
      base_scope = base_scope.where(category_id: category_id) if category_id.present?

      base_scope.includes(:category, :inventory_logs).ordered_by_urgency
    end
  end
end
