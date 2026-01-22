class InventoryService
  def initialize(item_class: Item, inventory_log_class: InventoryLog)
    @item = item_class
    @inventory_log = inventory_log_class
  end

  # item_paramsを受け取り、Itemと初期在庫のInventoryLogを作成する
  def self.create_item(params)
    item = @Item.new(params)

    transaction do
      item.save!

      # 初期在庫が0より大きい場合のみ、購入ログを記録する
      if item.has_stock?
        log = InventoryLog.new(
          item: item,
          change_amount: item.quantity,
          reason: :purchase
        )
        log.save!
      end
    end

    item
  rescue ActiveRecord::RecordInvalid => e
    item.errors.add(:base, "在庫ログの保存に失敗しました: #{e.record.errors.full_messages.join(', ')}")
    item
  end

  # 既存アイテムの在庫を変動させ、ログを作成する
  def self.change_quantity(item:, amount:, reason:)
    case reason.to_sym
    when :purchase
      item.increase_stock!(amount)
    when :consume, :dispose
      item.decrease_stock!(amount)
    else
      item.errors.add(:base, "不明な理由です: #{reason}")
      return false
    end
    InventoryLog.create!(item: item, change_amount: amount, reason: reason)
    true
  rescue => e
    item.errors.add(:base, e.message)
    false
  end
end
