class InventoryLog < ApplicationRecord
  belongs_to :item

  # バリデーション
  validates :change_amount, presence: true, numericality: true
  validates :reason, presence: true, inclusion: { in: InventoryReason::VALID_REASONS.map(&:to_s) }

  def self.record(item:, delta:, reason_key:)
    create!(
      item: item,
      change_amount: delta,
      reason: reason_key
    )
  end

  # インスタンスから InventoryReason ValueObject を取得するヘルパーメソッド
  def inventory_reason
    InventoryReason.new(reason)
  end
end
