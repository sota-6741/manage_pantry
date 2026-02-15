module InventoryUsecases
  class ShowInventoryLogUsecase
    def initialize(user:)
      @user = user
    end

    def call(item_id)
      item = @user.items.find(item_id)
      inventory_logs = item.inventory_logs.order(created_at: :desc)
      [ item, inventory_logs ]
    end
  end
end
