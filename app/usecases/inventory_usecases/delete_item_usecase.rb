module InventoryUsecases
  class DeleteItemUsecase
    def initialize(user:)
      @user = user
    end

    def call(item_id)
      item = @user.items.find(item_id)
      item.destroy!
    end
  end
end
