module InventoryUsecases
  class DeleteItemUsecase
    def initialize(item_model: Item)
      @item_model = item_model
    end

    def call(item_id)
      item = @item_model.find(item_id)
      item.destroy!
    end
  end
end
