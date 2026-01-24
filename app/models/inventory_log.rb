class InventoryLog < ApplicationRecord
  belongs_to :item

  # バリデーション
  # nullチェック
  validates :item_id, presence: true
  validates :change_amount, presence: true
  validates :reason, presence: true
  # change_amountは符号付きの数値
  validates :change_amount, numericality: true
  # reasonはInventoryReason::VALID_REASONSの値だけか？
  validates :reason, inclusion: { in: InventoryReason::VALID_REASONS.map(&:to_s) }

  def self.build(item:, amount:, reason_key:)
    inventory_reason = InventoryReason.new(reason_key)
    new(
      item: item,
      change_amount: inventory_reason.delta(amount),
      reason: inventory_reason.to_s
    )
  end

  def self.record(item:, delta:, reason_key:)
    create!(
      item: item,
      change_amount: delta,
      reason: reason_key.to_s
    )
  end

  # インスタンスから InventoryReason ValueObject を取得するヘルパーメソッド
  def inventory_reason
    InventoryReason.new(reason)
  end
end
