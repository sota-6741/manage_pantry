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

      base_scope.includes(:category, :inventory_logs).ordered_by_urgency
    end
  end
end
