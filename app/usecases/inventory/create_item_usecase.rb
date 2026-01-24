module Inventory
  class CreateItemUsecase
    def initialize(item_model: Item, inventory_log_model: InventoryLog)
      @item_model = item_model
      @inventory_log_model = inventory_log_model
    end

    def call(params)
      ActiveRecord::Base.transaction do
        item = @item_model.register(params)
        @inventory_log_model.record(item: item, delta: item.quantity, reason_key: :purchase)
        item
      end
    end
  end
end
