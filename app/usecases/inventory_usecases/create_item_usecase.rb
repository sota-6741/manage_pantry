module InventoryUsecases
  class CreateItemUsecase
    def initialize(user:, inventory_log_model: InventoryLog)
      @user = user
      @inventory_log_model = inventory_log_model
    end

    def call(params)
      ActiveRecord::Base.transaction do
        item = @user.items.create!(params)
        @inventory_log_model.record(item: item, delta: item.quantity, reason_key: :purchase)
        item
      end
    end
  end
end
