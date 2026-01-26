class UpdateItemUsecase
  def initialize(item_model: Item)
    @item_model = item_model
  end

  def call(item_id, params)
    @item_model.update(item_id, params)
    item
  end
end
