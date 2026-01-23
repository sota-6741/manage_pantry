class InventoryUsecase
  include ReasonDefinition
  attr_reader :item, :inventory_log

  def initialize(item_model, inventory_log_model)
    @item = item_model
    @inventory_log = inventory_log_model
  end

  # アイテム管理
  def create_item(params)
    ActiveRecord::Base.transaction do
      item = @item.new(params)
      item.save!
      inventory_log = @inventory_log.build(
        item: item,
        amount: item.quantity,
        reason: :purchase
      )
      inventory_log.save!
      item
    end
  end

  def update_item(item_id, params)
    item = @item.find(item_id)
    item.update!(params)
    item
  end

  def delete_item(item_id)
    item = @item.find(item_id)
    item.destroy!
  end

  # 在庫操作
  def change_stock(item_id:, amount:, reason:)
    raise ArgumentError, "理由が不適切です: #{reason}" unless reason.to_sym.in?(REASONS)
    item = @item.find(item_id)

    delta =
    case reason.to_sym
    when :purchase then amount
    when :consume, :dispose then -amount
    end

    @item.transaction do
      raise StandardError, "在庫が不足しています" unless item.can_change_quantity?(delta)
      item.update!(quantity: item.quantity + delta)
      @inventory_log.create!(
        item: item,
        change_amount: delta,
        reason: reason
      )
    end

    item
  end
end
