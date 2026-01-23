class InventoryLog < ApplicationRecord
  belongs_to :item

  enum reason: { purchase: 0, consume: 1, dispose: 2 }

  # バリデーション
  # nullチェック
  validates :item_id, presence: true
  validates :change_amount, presence: true
  validates :reason, presence: true
  # change_amountは符号付きの数値(そのほうが集計しやすいかも)
  validates :change_amount, numericality: true
  # reasonはenumの値だけか？
  validates :reason, inclusion: { in: reasons.keys }

  def self.build(item:, amount:, reason:)
    InventoryLog.create!(
      item: item,
      change_amount: amount_for_log(amount, reason),
      reason: reason
    )
  end

  private
  def signed_amount(amount, reason)
    case reason.to_sym
    when :purchase then amount
    when :consume, :dispose then -amount
    end
  end
end
