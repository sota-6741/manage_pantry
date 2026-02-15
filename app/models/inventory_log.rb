class InventoryLog < ApplicationRecord
  belongs_to :item

  # バリデーション
  validates :change_amount, presence: true, numericality: true
  validates :reason, presence: true, inclusion: { in: InventoryReasonDelta::VALID_REASONS.map(&:to_s) }

  def self.record(item:, delta:, reason_key:)
    create!(
      item: item,
      change_amount: delta,
      reason: reason_key
    )
  end

  # インスタンスから InventoryReasonDelta ValueObject を取得するヘルパーメソッド
  def inventory_reason_delta
    InventoryReasonDelta.new(reason)
  end

  def human_reason
    I18n.t("activerecord.attributes.inventory_log.reasons.#{reason}", default: reason)
  end
end
