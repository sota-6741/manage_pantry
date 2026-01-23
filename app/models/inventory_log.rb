class InventoryLog < ApplicationRecord
  belongs_to :item

  enum :reason, ReasonDefinition::REASONS

  # バリデーション
  # nullチェック
  validates :item_id, presence: true
  validates :change_amount, presence: true
  validates :reason, presence: true
  # change_amountは符号付きの数値(そのほうが集計しやすいかも)
  validates :change_amount, numericality: true
  # reasonはReasonDefinition.REASONの値だけか？
  validates :reason, inclusion: { in: ReasonDefinition::REASONS.map(&:to_s) }

  def self.build(item:, amount:, reason:)
    InventoryLog.new(
      item: item,
      change_amount: signed_amount(amount, reason),
      reason: reason
    )
  end

  def self.signed_amount(amount, reason)
    case reason.to_sym
    when :purchase then amount
    when :consume, :dispose then -amount
    end
  end

  private_class_method :signed_amount
end
