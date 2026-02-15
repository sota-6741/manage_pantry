module InventoryUsecases
  class ChangeStockUsecase
    def initialize(user:, inventory_log_model: InventoryLog)
      @user = user
      @inventory_log_model = inventory_log_model
    end

    def call(item_id:, amount:, reason_key:)
      item = @user.items.find(item_id)
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
