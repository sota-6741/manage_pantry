class InventoryUsecase
  def initialize(item_model: Item, inventory_log_model: InventoryLog)
    @item = item_model
    @inventory_log = inventory_log_model
  end

  # アイテム管理系
  def create_item(params)
    transition do
      item = @item.new(params)
      inventory_log = @inventory_log.build(
        item: item,
        amount: item.quantity,
        reason: purchase
      )
      item.save!
      inventory_log.save!
      item
    end
  end

  def edit_item(item_id, params)
    item = @item.find(item_id)
    item.update!(params)
    item
  end

  def delete_item(item_id)
    item = @item.find(item_id)
    item.destory!
  end

  # 在庫操作形
  def purchase(item_id, amount)
    change_stock(item_id, amount)
  end

  def dispose
end
