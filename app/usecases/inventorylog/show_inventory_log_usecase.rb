class ShowInventoryLogUsecase
  def initialize(item: Item)
    @item = item
  end

  def call(item_id)
    item = @item.find(item_id)
    inventory_logs = item.inventory_logs.order(created_at: :desc)
    [ item, inventory_logs ]
  end
end
