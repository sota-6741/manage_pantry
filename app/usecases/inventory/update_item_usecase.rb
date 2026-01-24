class UpdateItemUsecase
  def initialize(item: Item)
    @item = item
  end

  def call(item_id, params)
    item = @item.find(item_id)
    item.update!(params)
    item
  end
end
