module InventoryUsecases
  class DeleteItemUsecase
    def initialize(item_model: Item)
      @item_model = item_model
    end

    def call(item_id)
      @item_model.destroy(item_id)
    end
  end
end
