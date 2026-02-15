module InventoryUsecases
  class UpdateItemUsecase
    def initialize(user:)
      @user = user
    end

    def call(item_id, params)
      item = @user.items.find(item_id)
      item.update!(params)
      item
    end
  end
end
