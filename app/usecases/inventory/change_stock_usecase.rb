module Inventory
  class ChangeStockUsecase
    def initialize(item_model: Item, inventory_log_model: InventoryLog)
      @item_model = item_model
      @inventory_log_model = inventory_log_model
    end

    def call(item_id:, amount:, reason_key:)
      item = @item_model.fetch(item_id)
      reason_vo = InventoryReason.new(reason_key) # InventoryReason のインスタンスを生成
      delta = reason_vo.delta(amount)             # インスタンスメソッドを呼び出す

      ActiveRecord::Base.transaction do
        item.update_stock!(delta)
        @inventory_log_model.record(item: item, delta: delta, reason_key: reason_key)
        item
      end
    end
  end
end
