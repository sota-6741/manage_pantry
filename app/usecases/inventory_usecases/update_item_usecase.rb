module InventoryUsecases
  class UpdateItemUsecase
    def initialize(item_model: Item)
      @item_model = item_model
    end

    def call(item_id, params)
      item = @item_model.find(item_id)
      item.update!(params)
      item
    end
  end
end
