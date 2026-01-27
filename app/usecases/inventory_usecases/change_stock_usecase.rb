module InventoryUsecases
  class ChangeStockUsecase
    def initialize(item_model: Item, inventory_log_model: InventoryLog)
      @item_model = item_model
      @inventory_log_model = inventory_log_model
    end

    def call(item_id:, amount:, reason_key:)
      item = @item_model.find(item_id)
      inventory_reason = InventoryReasonDelta.new(reason_key)
      delta = inventory_reason.delta(amount)

      ActiveRecord::Base.transaction do
        item.update_stock!(delta)
        @inventory_log_model.record(item: item, delta: delta, reason_key: reason_key)
        item
      end
    end
  end
end
